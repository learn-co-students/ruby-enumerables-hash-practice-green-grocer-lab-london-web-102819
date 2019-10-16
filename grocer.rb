def consolidate_cart(cart)
receipt = {}
cart.each { |item_hash| 
  item_name = item_hash.keys[0]
  
  if receipt.has_key?(item_name)
    receipt[item_name][:count] +=1
    
  else
    receipt[item_name] = {
      count: 1,
      price: item_hash[item_name][:price],
      clearance: item_hash[item_name][:clearance]
    }
end
}
receipt
end

def apply_coupons(cart, coupons)
 coupons.each do |coupon|
 item = coupon[:item]
 if cart[item]
   if cart[item][:count] >= coupon[:num] && !cart.has_key?("#{item} W/COUPON")
     cart["#{item} W/COUPON"] = {price: coupon[:cost] / coupon[:num], clearance: cart[item][:clearance], count: coupon[:num]}
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
  cart.each do |item, stats|
    stats[:price] -= stats[:price] * 0.2 if stats[:clearance]
  end 
  cart
end

def checkout(cart, coupons)
  hash_cart = consolidate_cart(cart)
  applied_coupons = apply_coupons(hash_cart, coupons)
  applied_discount = apply_clearance(applied_coupons)
  total = applied_discount.reduce(0) {|acc, (key, value)| acc += value[:price] * value[:count]}
  total > 100 ? total * 0.9 : total
end
