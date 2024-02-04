class EnableEmailChannel < ActiveRecord::Migration[6.0]
  def change
    # Verificar se a coluna 'locked' existe antes de usá-la
    if InstallationConfig.column_names.include?('locked')
      current_config = InstallationConfig.where(name: 'ACCOUNT_LEVEL_FEATURE_DEFAULTS').last
      current_config.value.each { |v| v['enabled'] = true if %w[inbound_emails channel_email].include?(v['name']) }
      current_config.save!

      ConfigLoader.new.process

      Account.find_in_batches do |account_batch|
        account_batch.each do |account|
          account.enable_features('inbound_emails')
          account.enable_features('channel_email')
          account.save!
        end
      end
    else
      # Lógica alternativa, se necessário
    end
  end
end