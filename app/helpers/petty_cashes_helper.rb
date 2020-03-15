module PettyCashesHelper
  include ActionView::Helpers::NumberHelper

  def for_account # For choosing petty cash account type
    url_array = request.original_url.split(/[\/,?]/)
    if url_array.include?('petty_cashes')
      return 'Cash'
    elsif url_array.include?('mpesaes')
      return 'Bank'
    elsif url_array.include?('petty_cash_nbos')
      return 'NBO'
    else
      return ''
    end
  end
end
