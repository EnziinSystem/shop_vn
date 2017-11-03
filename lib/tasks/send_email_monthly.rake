desc 'send email monthly'
task send_email_monthly: :environment do
  users = User.all
  users.each do |user|
    SendEmailMonthlyJob.perform_later(user)
  end
end