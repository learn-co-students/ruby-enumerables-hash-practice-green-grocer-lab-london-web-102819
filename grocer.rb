def consolidate_cart(cart)
  consolidated_cart = {}
  i = 0
  while i < cart.length do
    food_type = cart[i].keys[0] #=> "Avocado", "Kale", etc
    if consolidated_cart.include?(food_type) 
      consolidated_cart[food_type][:count] += 1
    else
      consolidated_cart.merge!(cart[i])
      consolidated_cart[food_type][:count] = 1
    end 
    i += 1   
  end
  cart = consolidated_cart
  return cart
end

def apply_coupons(cart, coupons)
  discount_cart = {}
  i = 0 #coupon counter
  
  while i < coupons.length do 
    
    coupon_food = coupons[i][:item] #"AVOCADO", etc.
    coupon_number = coupons[i][:num]
    coupon_cost = coupons[i][:cost]
    
      if cart.include?(coupon_food) && cart[coupon_food][:count] >= coupon_number
        
        #APPLY COUPON
        if cart.include?("#{coupon_food} W/COUPON")
          cart[coupon_food][:count] -= coupon_number
          cart["#{coupon_food} W/COUPON"][:count] += coupon_number
        else
        cart[coupon_food][:count] -= coupon_number
        new_item={"#{coupon_food} W/COUPON" => {:price => (coupon_cost / coupon_number), :clearance => cart[coupon_food][:clearance], :count => coupon_number}}
        cart.merge!(new_item)
      end
      end
      i +=1 
    end
    return cart
end

def apply_clearance(cart)
  i = 0
  while i < cart.length do 
    item = cart.keys[i]
    if cart[item][:clearance] 
      cart[item][:price] *= 0.8
      cart[item][:price] = cart[item][:price].round(2)
    end
    i += 1 
  end
  return cart
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  
total = 0 
i = 0
  while i < cart.length do 
    item = cart.keys[i]
    price = cart[item][:price]
    count = cart[item][:count]
    total += price * count
    i += 1 
  end 
    
    if total > 100
      total *= 0.9
    end
    return total 
end
