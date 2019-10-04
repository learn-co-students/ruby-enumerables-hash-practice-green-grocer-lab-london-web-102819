def consolidate_cart(cart)
  nc = {}
  gl = []
  cart.each do |item|
    item.reduce({}) do |memo, (key,value)|
        gl.push(key)
        nc[key] = value
        value[:count] = gl.count(key)
        memo
      end
    end
  nc
end

def apply_coupons(cart, coupons)
  ua = {}
  cart.reduce({}) do |memo, (key,value)|
    coupons.each do |e|
      if e[:item] == key && value[:count] >= e[:num]
        value[:count] -= e[:num]
        if ua["#{key} W/COUPON"]
          cc = ua["#{key} W/COUPON"][:count]
          ua["#{key} W/COUPON"] = {price: e[:cost]/e[:num], clearance: value[:clearance], count: cc + e[:num]}
        else
          ua["#{key} W/COUPON"] = {price: e[:cost]/e[:num], clearance: value[:clearance], count: e[:num]}
        end
      end
    end
  end
  cart.merge(ua)
end

def apply_clearance(cart)
  new_hash = {}
  cart.reduce({}) do |memo, (key, value)|
    if value[:clearance]
      value[:price] = (0.8*value[:price]).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  cart = apply_clearance(apply_coupons(consolidate_cart(cart), coupons))
  total = 0
  cart.reduce({}) do |memo, (key, value)|
    total += value[:price]*value[:count]
  end
  if total > 100
    total *= 0.9
  end
 total
end
