namespace :move_remarks_to_remarks_table do
  desc "Here we are moving remarks field content to remark table"
  task move: :environment do
    puts "Starting the task execution..."
    Import.all.each do |element|
      remarks = []
      element.audits.each do |audit|
        if audit.audited_changes.key?(:remarks)
          audit.audited_changes[:remarks].each_with_index do |remark, index|
            remarks.push({category: "external", date: audit.audited_changes[:updated_at][index].to_s, desc: remark})  unless remark.to_s.blank?
          end
        end
      end
      element.remarks.create(remarks.uniq! {|a| a[:desc] })
    end
    puts "Completed the import remarks and starting with import item..."
    ImportItem.all.each do |element|
      remarks = []
      element.audits.each do |audit|
        if audit.audited_changes.key?(:remarks)
          audit.audited_changes[:remarks].each_with_index do |remark, index|
            remarks.push({category: "external", date: audit.audited_changes[:updated_at][index].to_s, desc: remark}) unless remark.to_s.blank?
          end
        end
      end
      element.remarks.create(remarks.uniq! {|a| a[:desc] })
    end
    puts "Completed import item"
    puts "Moved all the data from remark field to remarks table..."
  end
end
