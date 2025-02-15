namespace :spree_sample do
  desc 'Create sample marketplace orders'
  task marketplace_orders: :environment do
    if Spree::Order.count == 0
      puts 'Please run `rake spree_sample:load` first to create products and orders'
      exit
    end

    if Spree::Supplier.count == 0
      puts 'Please run `rake spree_sample:suppliers` first to create suppliers'
      exit
    end

    count = 0
    @orders = Spree::Order.complete.includes(:line_items).all
    @suppliers = Spree::Supplier.all

    puts 'Linking existing line items to suppliers'
    Spree::LineItem.all.each do |li|
      print "*" if li.product.add_supplier! @suppliers.shuffle.first.id and li.save
    end
    puts

    puts 'Creating marketplace orders for existing orders'
    Spree::Order.all.each do |order|
      print '*' if order.finalize!
    end
    puts
  end

  desc 'Create sample suppliers and randomly link to products'
  task suppliers: :environment do
    old_send_value = SolidusMarketplace::Config.send_supplier_email
    SolidusMarketplace::Config.send_supplier_email = false

    @usa = Spree::Country.find_by_iso('US')
    @ca = @usa.states.find_by_abbr('CA')

    count = Spree::Supplier.count
    puts 'Creating Suppliers...'
    5.times{|i|
      name = "Supplier #{count + i + 1}"
      user = Spree::User.create(email: "supplier#{i}@example.com", password: 'test123')
      user.spree_roles << Spree::Role.find_by(name: "supplier_admin")
      supplier = Spree::Supplier.new(name: name,
                                     user_id: user.id,
                                     url: 'http://example.com',
                                     admins: [user])
      supplier.build_address(firstname: name,
                             lastname: name,
                             address1: '100 State St',
                             city: 'Santa Barbara',
                             zipcode: '93101',
                             state_id: @ca.id,
                             country_id: @usa.id,
                             phone: '1234567890')
      print '*' if supplier.save
    }
    puts
    puts "#{Spree::Supplier.count - count} suppliers created"

    puts 'Randomly linking Products & Suppliers...'

    @supplier_ids = Spree::Supplier.pluck(:id).shuffle
    @products = Spree::Product.all
    count = 0

    @products.each do |product|
      product.add_supplier! Spree::Supplier.find(@supplier_ids[rand(@supplier_ids.length)])
      product.save
      count += 1
      print "*"
    end

    puts
    puts "#{count} products linked."
    SolidusMarketplace::Config.send_supplier_email = old_send_value
  end
end
