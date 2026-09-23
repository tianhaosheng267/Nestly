




Rails.application.config.filter_parameters += [
  :code, :state, :recipient, :body, :subject, :code_verifier,
  :passw, :email, :secret, :token, :_key, :crypt, :salt, :certificate, :otp, :ssn, :cvv, :cvc
]
