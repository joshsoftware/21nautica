module SparePartsHelper

  def spare_part_sub_categories
    if @spare_part.persisted?
      if @spare_part.spare_part_category
        @spare_part.spare_part_category.spare_part_categories.pluck(:name, :id)
      else
        []
      end
    else
      []
    end
  end

  def get_spare_part
    SparePart.pluck(:product_name, :id) 
  end
end
