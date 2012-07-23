module SmartAnswer::Calculators
  class MinimumWageCalculator
  
    ACCOMMODATION_CHARGE_THRESHOLD = 4.73
    
    HISTORICAL_MINIMUM_WAGES = {
      "2012" => [3.68, 4.98, 6.08],
      "2011" => [3.68, 4.98, 6.08],
      "2010" => [3.64, 4.92, 5.93],
      "2009" => [3.57, 4.83, 5.80],
      "2008" => [3.53, 4.77, 5.73],
      "2007" => [3.40, 4.60, 5.52],
      "2006" => [3.30, 4.45, 5.35],
      "2005" => [3.00, 4.25, 5.05]
    }
    
    def per_hour_minimum_wage(age, year = Date.today.year)
      wages = HISTORICAL_MINIMUM_WAGES[year.to_s]
      if age < 18
        wages[0]
      # Before 2010 the mid-age range was 18 to 21, after 2010 it was 18 to 20
      elsif age >= 18 and ((year < 2010 and age < 22) or (age < 21))
        wages[1]
      else
        wages[2]
      end
    end
    
    def apprentice_rate
      2.6
    end

    def per_week_minimum_wage(age, hours_per_week)
      (hours_per_week.to_f * per_hour_minimum_wage(age)).round(2)
    end

#    def per_piece_hourly_wage(pay_per_piece, pieces_per_week, hours_per_week)
#      (pay_per_piece.to_f * pieces_per_week.to_f / hours_per_week.to_f).round(2)
#    end

    def is_below_minimum_wage?(age, total_hourly_rate)
      total_hourly_rate.to_f < per_hour_minimum_wage(age)
    end

#    def is_below_minimum_wage?(age, pay_per_piece, pieces_per_week, hours_per_week)
#      per_piece_hourly_wage(pay_per_piece, pieces_per_week, hours_per_week).to_f < per_hour_minimum_wage(age)
#    end
    
    def accommodation_adjustment(charge, number_of_nights)
      charge = charge.to_f
      number_of_nights = number_of_nights.to_i
      
      if charge > 0
        charged_accomodation_adjustment(charge, number_of_nights) 
      else
        free_accommodation_adjustment(number_of_nights)
      end
    end
    
    protected
    
    def free_accommodation_adjustment(number_of_nights)
      (ACCOMMODATION_CHARGE_THRESHOLD * number_of_nights).round(2)
    end
    
    def charged_accomodation_adjustment(charge, number_of_nights)
      if charge < ACCOMMODATION_CHARGE_THRESHOLD
        0
      else
        (free_accommodation_adjustment(number_of_nights) - (charge * number_of_nights)).round(2)
      end
    end
  end
end
