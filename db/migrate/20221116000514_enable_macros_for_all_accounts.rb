class EnableMacrosForAllAccounts < ActiveRecord::Migration[6.1]
  def change
    current_config = InstallationConfig.find_or_create_by(name: 'ACCOUNT_LEVEL_FEATURE_DEFAULTS')
    
    # Ensure serialized_value is a hash
    current_config.serialized_value = {} unless current_config.serialized_value.is_a?(Hash)

    current_config.serialized_value.each do |feature_name, feature_value|
      if feature_name == 'macros'
        feature_value['enabled'] = true if feature_value['name'] == 'macros'
      end
    end

    current_config.save!

    ConfigLoader.new.process

    Account.find_in_batches do |account_batch|
      account_batch.each do |account|
        account.enable_features('macros')
        account.enable_features('channel_email')
        account.save!
      end
    end
  end
end
