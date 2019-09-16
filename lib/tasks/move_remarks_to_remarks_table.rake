namespace :move_remarks_to_remarks_table do
  desc "Here we are moving remarks field content to remark table"
  task move: :environment do
    puts "Starting the task execution..."
    Import.where.not(remark: ["", nil]).each do |element|
      element.remarks.create(category: "external", date: element.updated_at, desc: element.remark)
    end

    # Movement.where.not(remark: ["", nil]).each do |element|
    #   element.remarks.create(category: "external", date: element.updated_at, desc: element.remark)
    # end

    ImportItem.where.not(remark: ["", nil]).each do |element|
      element.remarks.create(category: "external", date: element.updated_at, desc: element.remark)
    end

    # BillOfLading.where.not(remark: ["", nil]).each do |element|
    #   element.remarks.create(category: "external", date: element.updated_at, desc: element.remark)
    # end

    # Payment.where.not(remark: ["", nil]).each do |element|
    #   element.remarks.create(category: "external", date: element.updated_at, desc: element.remark)
    # end

    # Invoice.where.not(remark: ["", nil]).each do |element|
    #   element.remarks.create(category: "external", date: element.updated_at, desc: element.remark)
    # end

    # Bill.where.not(remark: ["", nil]).each do |element|
    #   element.remarks.create(category: "external", date: element.updated_at, desc: element.remark)
    # end

    puts "Moved all the data from remark field to remarks table..."
  end
end
