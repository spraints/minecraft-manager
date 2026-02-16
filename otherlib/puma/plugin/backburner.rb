require "puma/plugin"

$stderr.puts "LOAD BACKBURNER PLUGIN"

Puma::Plugin.create do
  attr_reader :puma_pid, :backburner_pid, :log_writer

  def start(launcher)
    @log_writer = launcher.log_writer
    @puma_pid = $$

    fork_backburner(launcher)
  end

  private

  def fork_backburner(launcher)
    in_background do
      monitor_backburner
    end

    if Gem::Version.new(Puma::Const::VERSION) < Gem::Version.new("7")
      launcher.events.on_booted do
        @backburner_pid = fork do
          $0 = "backburner worker"
          Thread.new { monitor_puma }
          Backburner.work
        end
      end

      launcher.events.on_stopped { stop_backburner_fork }
      launcher.events.on_restart { stop_backburner_fork }
    else
      launcher.events.after_booted do
        @backburner_pid = fork do
          $0 = "backburner worker"
          Thread.new { monitor_puma }
          Backburner.work
        end
      end

      launcher.events.after_stopped { stop_backburner_fork }
      launcher.events.before_restart { stop_backburner_fork }
    end
  end

  def stop_backburner_fork
    Process.waitpid(backburner_pid, Process::WNOHANG)
    log "Stopping Backburner..."
    Process.kill(:INT, backburner_pid) if backburner_pid
    Process.wait(backburner_pid)
  rescue Errno::ECHILD, Errno::ESRCH
  end

  def monitor_puma
    monitor(:puma_dead?, "Detected Puma has gone away, stopping Backburner...")
  end

  def monitor_backburner
    monitor(:backburner_fork_dead?, "Detected Backburner has gone away, stopping Puma...")
  end

  def monitor(process_dead, message)
    loop do
      if send(process_dead)
        log message
        Process.kill(:INT, $$)
        break
      end
      sleep 2
    end
  end

  def backburner_fork_dead?
    if backburner_started?
      Process.waitpid(backburner_pid, Process::WNOHANG)
    end
    false
  rescue Errno::ECHILD, Errno::ESRCH
    true
  end

  def backburner_started?
    backburner_pid.present?
  end

  def puma_dead?
    Process.ppid != puma_pid
  end

  def log(...)
    log_writer.log(...)
  end
end
