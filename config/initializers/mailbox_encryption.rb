# Token encryption uses the application's stable secret. Preserve SECRET_KEY_BASE
# across production restarts. No OAuth tokens are stored in cookies or plaintext.
Rails.application.config.active_record.encryption.primary_key = Rails.application.key_generator.generate_key('nestly-mailbox-primary', 32).unpack1('H*')
Rails.application.config.active_record.encryption.deterministic_key = Rails.application.key_generator.generate_key('nestly-mailbox-deterministic', 32).unpack1('H*')
Rails.application.config.active_record.encryption.key_derivation_salt = Rails.application.key_generator.generate_key('nestly-mailbox-salt', 32).unpack1('H*')
