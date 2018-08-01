namespace :req do
  desc 'associate spare part with spare part category'
  task associate_spart_part: :environment do 
    part = SparePartCategory.find_or_create_by(name: 'Engine')
    ['Cylinder Head', 'Crankcase', 'Crankshaft,Conrod and Flywheel', 'Piston and Liner', 'Camshaft', 'Oil Sump', 'Engine Suspension', 'Intake and Exhaust Manifold'].each do |sub_part|
      part.spare_part_categories.find_or_create_by(name: sub_part)
    end

    part = SparePartCategory.find_or_create_by(name: 'Lubrication System')
    ['Oil Pump', 'Oil Filter', 'Oil Cooler', 'Oil Dipstick'].each do |sub_part|
      part.spare_part_categories.find_or_create_by(name: sub_part)
    end

    part = SparePartCategory.find_or_create_by(name: 'Fuel System')
    ['Fuel Pump', 'Injector Unit', 'Fuel Filter', 'Fuel Tank'].each do |sub_part|
      part.spare_part_categories.find_or_create_by(name: sub_part)
    end

    part = SparePartCategory.find_or_create_by(name: 'Exhaust System')
    ['Silencer and Pipes', 'Clamps', 'Exhaust Breaks', 'Turbo Charger', 'Air Filter', 'Urea Tank'].each do |sub_part|
      part.spare_part_categories.find_or_create_by(name: sub_part)
    end

    part = SparePartCategory.find_or_create_by(name: 'Cooling System')
    ['Radiator', 'Intercooler', 'Expansion Tank', 'Fan', 'Belt Tensioner', 'V Belt', 'Water Pump', 'Thermostat'].each do |sub_part|
      part.spare_part_categories.find_or_create_by(name: sub_part)
    end

    part = SparePartCategory.find_or_create_by(name: 'Accelerator Pedal and Battery')

    part = SparePartCategory.find_or_create_by(name: 'Alternator')
    ['Alternator', 'Belt Tensioner', 'V Belt'].each do |sub_part|
      part.spare_part_categories.find_or_create_by(name: sub_part)
    end

    part = SparePartCategory.find_or_create_by(name: 'Starter')
    part = SparePartCategory.find_or_create_by(name: 'Lighting and Bulbs')
    part = SparePartCategory.find_or_create_by(name: 'Elextrical Equipment')
    ['Switches', 'Relays and Contacts', 'Cable Harness', 'Valves', 'Wiper and Horn'].each do |sub_part|
      part.spare_part_categories.find_or_create_by(name: sub_part)
    end

    part = SparePartCategory.find_or_create_by(name: 'Instruments')
    ['Instrument Panel', 'Contact and Sensors', 'Fuel Sensor'].each do |sub_part|
      part.spare_part_categories.find_or_create_by(name: sub_part)
    end

    part = SparePartCategory.find_or_create_by(name: 'Clutch')
    ['Clutch Cover and Disk', 'Release Fork', 'Pedal and Cylinder', 'Clutch Servo'].each do |sub_part|
      part.spare_part_categories.find_or_create_by(name: sub_part)
    end
    
    part = SparePartCategory.find_or_create_by(name: 'Gear Box')
    ['Gear Shift Lever', 'Housing', 'Switches and Sensor', 'Control Housing', 'Range and Split Cylinder', 'Oil Pump and Oil Cooler', 'Oil Filter', 'Input Shaft', 'Main Shaft', 'Counter Shaft', 'Planetary Gear'].each do |sub_part|
      part.spare_part_categories.find_or_create_by(name: sub_part)
    end

    part = SparePartCategory.find_or_create_by(name: 'Propellor Shaft')
    part = SparePartCategory.find_or_create_by(name: 'Rear Axle')
    part = SparePartCategory.find_or_create_by(name: 'Break System')
    ['Brake Drum', 'Z-cam and break Shaft', 'Disk BReaK', 'Brake Cylinder', 'Compressor', 'Air Dryer', 'Valves', 'Sensors', 'Retarder', 'Air Tank'].each do |sub_part|
      part.spare_part_categories.find_or_create_by(name: sub_part)
    end

    part = SparePartCategory.find_or_create_by(name: 'Fron Axle')
    part = SparePartCategory.find_or_create_by(name: 'Steering')
    part = SparePartCategory.find_or_create_by(name: 'Suspension Front Axle')
    part = SparePartCategory.find_or_create_by(name: 'Suspension Rear Axle')
    part = SparePartCategory.find_or_create_by(name: 'Hubs and Wheels')
    part = SparePartCategory.find_or_create_by(name: 'Cabin Suspension')
    part = SparePartCategory.find_or_create_by(name: 'Cabin outer')
  end
end
