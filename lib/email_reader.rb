require 'mail'
require 'nokogiri'
require 'timeout'

class EmailReader

  def initialize(email, password)
    @email = email
    @password = password
    Mail.defaults do
      retriever_method :imap,
                       address: "imap.gmail.com",
                       port: 993,
                       user_name: email,
                       password:  password,
                       enable_ssl: true
    end
  end

  def self.get_new_password_from_message(message, password_xpath)
     # Forgot password email is multipart base64 encoded,The new password is within the body,
    mail_body = message.parts[0].body.decoded
    html_doc = Nokogiri::HTML mail_body
    password = html_doc.xpath(password_xpath)
    raise 'Could not find password in email' if password.length == 0
    password[0].text
  end

  def find_unread_email_with_subject(subject, from, timeout_secs, mark_read=false)
    Kernel::puts "Waiting for '#{subject}' email"
    messages = []
    begin
      Timeout::timeout(timeout_secs) do
        until messages.length > 0 do
          messages = Mail.find(what: :last, keys: ['UNSEEN', 'FROM', from, 'SUBJECT', subject], read_only: !mark_read )
          sleep 1
          Kernel::print '.'
        end
      end
      Kernel::puts 'Received'
    rescue Exception => e
      puts "Could not find unread '#{subject}' email"
      puts e.message
    end
    messages.last
  end

  def mark_emails_as_read(subject, from)
    message = Mail.find(keys: ['UNSEEN', 'FROM', from, 'SUBJECT', subject]) do |email, imap, uid|
        imap.uid_store( uid, "+FLAGS", [Net::IMAP::SEEN] )
    end
  end
end