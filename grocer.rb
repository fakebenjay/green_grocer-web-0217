require 'pry'

def consolidate_cart(cart)
  item_hash = {}

  cart.each do |hash|
    hash.each do |item, info|
      info_hash = {}

      info_hash[:price] = hash[item][:price]
      info_hash[:clearance] = hash[item][:clearance]
      info_hash[:count] = cart.count(hash)

      item_hash[item] = info_hash
    end
  end
  return item_hash
end

def apply_coupons(cart, coupons)
  discount_cart = {}

  cart.each do |item, info|
    discount_cart[item] = cart[item]
    counter = 1

    coupons.each do |coupon|
      coupon.each do |hash, key|
        if item == coupon[hash] && discount_cart[item][:count] >= coupon[:num]
          ## To see if the coupon is for that particular item and to
          ## ensure that the coupons don't apply to more items than I'm buying
          discount_cart[item][:count] -= coupon[:num]
          discount_cart["#{item} W/COUPON"] = {}
          discount_cart["#{item} W/COUPON"][:price] = coupon[:cost]
          discount_cart["#{item} W/COUPON"][:clearance] = cart[item][:clearance]
          discount_cart["#{item} W/COUPON"][:count] = counter
          counter += 1
        end
      end
    end
  end
  return discount_cart
end

def apply_clearance(cart)
  cart.each do |item, info|
    if cart[item][:clearance] == true
      cart[item][:price] = (cart[item][:price]*0.8).round(2)
      #round(2) is needed because 80% of $3.00 is not exactly $2.40 for some reason
    end
  end
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)

  total = 0
  cart.each do |item, info|
    total += info[:price]*info[:count]
  end



  if total > 100
    total = total*0.9
  end
  return total
end
