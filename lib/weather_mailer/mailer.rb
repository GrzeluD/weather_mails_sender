class Mailer 
  
  def initialize(options)
    Pony.options = options
  end
  
  def mail_details(details)
    @to           = details[:to]
    @from         = details[:from]
    subject       = details[:subject]
    template_path = details[:template_path]
    
    context = binding
    body = ERB.new(File.new(template_path).read).result(context)
    Pony.mail(:to => @to, :from => @from, :subject => subject, :html_body => body)
  end
end