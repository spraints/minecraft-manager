class MinecraftWorld < ApplicationRecord
  validates :display_name, presence: true
  validates :backend_addr, presence: true, format: { with: /\A([^:]+):(\d+)\z/ }

  validate :cannot_change, except_on: :create

  def cannot_change
    errors.add :display_name, "cannot be changed after creation" if changed?
  end
end
