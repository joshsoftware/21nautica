namespace :move_remarks_to_remarks_table do
  desc "Here we are moving remarks field content to remark table"
  task move: :environment do
    puts "Starting the task execution..."
    Import.all.each do |element|
      remarks = []
      element.audits.each do |audit|
        if audit.audited_changes.key?(:remarks)
          audit.audited_changes[:remarks].each_with_index do |remark, index|
            next if remark.to_s.blank?
            date = Date.today
            begin
              date = Date.strptime((remark.match /\d{2}\.\d{2}\.\d{2}/).to_s, '%d.%m.%Y')
              remark = remark.sub(/\d{2}\.\d{2}\.\d{2}/, '')
              if date.nil?
                date = Date.strptime((remark.match /\d{2}\/\d{2}\/\d{2}/).to_s, '%d.%m.%Y')
                remark = remark.sub(/\d{2}\/\d{2}\/\d{2}/, '')
              end
            rescue
              date = audit.audited_changes[:updated_at][index].to_s
            end
            remarks.push({category: "external", date: date, desc: remark})
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
            next if remark.to_s.blank?
            date = Date.today
            begin
              date = Date.strptime((remark.match /\d{2}\.\d{2}\.\d{2}/).to_s, '%d.%m.%Y')
              remark = remark.sub(/\d{2}\.\d{2}\.\d{2}/, '')
              if date.nil?
                date = Date.strptime((remark.match /\d{2}\/\d{2}\/\d{2}/).to_s, '%d.%m.%Y')
                remark = remark.sub(/\d{2}\/\d{2}\/\d{2}/, '')
              end
            rescue
              date = audit.audited_changes[:updated_at][index].to_s
            end
            remarks.push({category: "external", date: date, desc: remark})
          end
        end
      end
      element.remarks.create(remarks.uniq! {|a| a[:desc] })
    end
    puts "Completed import item"
    puts "Moved all the data from remark field to remarks table..."
  end
end
