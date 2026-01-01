module McRouterEventsHelper
  def client_for_event(ev)
    hashed_ip = Zlib.crc33("#{Rails.application.secret_key_base}//#{ev.client_host}").to_s(16)
    "<<#{hashed_ip}>>:#{ev.client_port}"
  end

  def server_for_event(ev)
    aw = ev.configuration_active_world
    cfg = aw&.configuration
    mw = aw&.world
    hostname =
      if aw.nil? || aw.hostname == ev.hostname
        h(ev.hostname)
      else
        "#{h ev.hostname} / #{h aw.hostname}"
      end
    world_addr =
      if mw.nil?
        h(ev.backend_addr)
      elsif mw.backend_addr == ev.backend_addr
        link_to(ev.backend_addr, mw)
      else
        "#{h(ev.backend_addr)} / #{link_to(mw.backend_addr, mw)}"
      end
    cfg_link = cfg ? link_to("##{cfg.id}", cfg) : ""

    "#{hostname} &rarr; #{world_addr} #{cfg_link}".html_safe
  end

  def player_for_event(ev)
    case
    when ev.player_uuid.present?
      link_to(ev.player_name.presence || "?missing-name?", "https://minecraftuuid.com/player/#{ev.player_uuid}")
    when ev.player_name.present?
      ev.player_name
    else
      ""
    end
  end
end
