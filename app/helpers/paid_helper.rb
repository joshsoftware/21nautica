module PaidHelper
  def get_vendors
    transporters =  Vendor.transporters.pluck(:name,:id).to_h
    clearing_agents = Vendor.clearing_agents.pluck(:name, :id).map { |agent| [agent[0]+"(CA)", agent[1]] }
    vendors = transporters.merge(clearing_agents.to_h)
  end
end
