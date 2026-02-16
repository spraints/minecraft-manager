# ConfigurationRetirement ensures that only one configuration is "applied".
class ConfigurationRetirement
  def self.apply
    Configuration.transaction do
      current = Configuration.current
      Configuration.applied.where("id <> ?", current.id).update_all(updated_at: Time.now, state: "retired")
    end
  end
end
