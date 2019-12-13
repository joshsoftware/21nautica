class InternalEmail < ActiveRecord::Base
  validates_format_of :emails, with: /\A^((\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*)*([,])*|\s)*$\z/
  enum email_type:["Container returned date report","Daily mail about purchase summary","Daily mail about daily purchase","Summary email daily"]
end
