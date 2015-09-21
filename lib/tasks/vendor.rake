namespace "vendor" do
  desc "Add Vendor id to each Movement"
  task add_to_movement: :environment do
    Movement.all.each do |movement|
      vendor_id = Vendor.where(name: movement.transporter_name).first.try(:id)
      movement.vendor_id= vendor_id
      movement.save!
    end
  end

  desc "Add Vendor id to each ImportItem"
  task add_to_import_item: :environment do
    ImportItem.all.each do |item|
      vendor_id = Vendor.where(name: item.transporter_name).first.try(:id)
      item.vendor_id= vendor_id
      item.save!
    end
  end

  #desc "Add type-transporter to existing vendors"
  #task add_transporter_type: :environment do
    #Vendor.all.each do |vendor|
      #vendor.update(vendor_type: "transporter")
    #end
  #end

  desc "Add Clearing agent to vendors"
  task add_clearing_agents: :environment do
    %W(Panafrica EACL Agility Paul).each do |agent_name|
      Vendor.create(name: agent_name, vendor_type: "clearing_agent")
    end
  end

  desc "Add clearing agent id to each Import"
  task clearing_agents_to_import: :environment do
    Import.all.each do |import|
      import.clearing_agent_id = Vendor.where(name: import.clearing_agent).first.try(:id)
      import.save!
    end
  end

  desc "Add clearing_agent id to each Movement"
  task clearing_agents_to_movement: :environment do
    Movement.all.each do |movement|
      movement.clearing_agent_id = Vendor.where(name: movement.clearing_agent).first.try(:id)
      movement.save!
    end
  end

end
