module ConfigFile
    SECRET_KEY = 'ASOFJISAJFA3124J23H41H2G4L1KJ24HJ12L4123K4124B1242'
    HASH = 'HS256'
    PREFERENCE_TYPES = {common: ["gender","race","age","search_radius","height","waist","hips"],
                        male: ["chest"],
                        female: ["bust"] }
    UPDATED_PREFERENCE_TYPES = {common: ["gender", "search_radius"] }
    RACES = [
        "Asian","Ebony","Caucasian","Latin","Other"
    ]

    SUBSCRIPTION_PRICING = {
      standard: {
        pricing: 100,
        rate: "Upto 350$/HR",
        max: 350
      },
      premium: {
        pricing: 150,
        rate: "Upto 1000$/HR",
        max: 1000
      },
      elite: {
        pricing: 200,
        rate: "More than 1000$/HR",
        max: 2000
      }
    }

    IAP_PRODUCT_ID = "com.companymapp.CompanyMappAgent.standard_plan_weekly"

    BRACKET_PRICING ={
      standard: 400,
      premium: 1000,
      elite: 5000
    }

    ERROR_LAT = 0.00999999999 #0.0
    ERROR_LNG = 0.00994637681 #0.0

    MONTHS = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
end
