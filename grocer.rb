def consolidate_cart(cart)
  new_cart = {} 
  cart.each do |items_array| 
    items_array.each do |item, attribute_hash| 
      new_cart[item] ||= attribute_hash 
      if new_cart[item][:count] then 
        new_cart[item][:count] += 1
      else 
        new_cart[item][:count] = 1
      end
    end 
  end 
  new_cart
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    item = coupon[:item]
    if cart.has_key?(item)
      if cart[item][:count] >= coupon[:num] && !cart.has_key?("#{item} W/COUPON")
        cart["#{item} W/COUPON"] = {price: coupon[:cost]/coupon[:num],
                                    clearance: cart[item][:clearance], 
                                    count: coupon[:num]
                                    }
        cart[item][:count] -= coupon[:num]
      elsif cart[item][:count] >= coupon[:num] && cart.has_key?("#{item} W/COUPON")
        cart["#{item} W/COUPON"][:count] += coupon[:num]
        cart[item][:count] -= coupon[:num]
      end
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |product, stats|
    stats[:price] -= stats[:price] * 0.2 if stats[:clearance] == true
  end
  cart
end

def checkout(cart, coupons)
  hash_cart = consolidate_cart(cart)
  applied_coupons = apply_coupons(hash_cart, coupons)
  applied_clearance = apply_clearance(applied_coupons)
  
  total = 0
  applied_clearance.each do |item, stats|
    total = total + (stats[:price] * stats[:count])
  end
  total > 100 ? total * 0.9 : total
end
