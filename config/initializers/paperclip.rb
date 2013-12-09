# config/initializers/paperclip.rb
Paperclip::Attachment.default_options[:s3_host_name] = 'sonicraph.s3.amazonaws.com'