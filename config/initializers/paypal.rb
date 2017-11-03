PAYPAL_CONFIG = YAML.load(File.read(Rails.root.join('config', 'paypal.yml')))[Rails.env]

PAYPAL_OPTIONS = {
    login: PAYPAL_CONFIG['login'],
    password: PAYPAL_CONFIG['password'],
    signature: PAYPAL_CONFIG['signature']
}
