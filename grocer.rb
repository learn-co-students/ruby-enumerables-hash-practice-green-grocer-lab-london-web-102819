def consolidate_cart(cart)
  hash = {};
  i=0;
  while i<cart.length do
    cart[i].each{
      |product_name,properties| 
    if hash.key?(product_name)==false
      properties.store(:count, 1)
    else
      properties[:count]= properties[:count]+1;
    end 
    hash.store(product_name,properties)
    }
    i+=1
  end
  return hash;
end


def apply_coupons(cart, coupons)
  hash=cart.clone;
  coupons.each{|coupon|
    product=coupon[:item]
    if hash.key?(product)==true
      #updating number in the cart 
      if hash[product][:count] < coupon[:num]
        next
      end
      hash[product][:count]-=coupon[:num]
      product_w_coupon={
        :price=>coupon[:cost]/coupon[:num],
        :clearance=>hash[product][:clearance],
        :count=>coupon[:num]
      }
      if hash.key?(product +" W/COUPON")==true
        hash[product+" W/COUPON"][:count]+=coupon[:num]
      else
        hash.store(product +" W/COUPON",product_w_coupon)
      end  
    end
    }
  return hash
end

def apply_clearance(cart)
  cart.each{|product,keys|
  if keys[:clearance]==true
    keys[:price]=(keys[:price]-0.2*keys[:price]).round(2)
    end
  }
  return cart
end

def checkout(cart, coupons)
  cart1=consolidate_cart(cart)
  cart_w_coupons=apply_coupons(cart1,coupons)
  cart_w_clearance=apply_clearance(cart_w_coupons)
  
  total=0
  
  cart_w_coupons.each{|product,keys|
  total+=keys[:price]*keys[:count]
}
if total>100
 total=total-0.1*total
  end
return total
end
