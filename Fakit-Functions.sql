


-- INSTALL fakeit FROM community;
LOAD fakeit;

-------------------
--Address Functions
-------------------

Select 
fakeit_address_street(), -- Full street address
fakeit_address_street_number(), -- Street number
fakeit_address_street_name(), -- Street name
fakeit_address_street_prefix(), -- Street prefix (e.g., "N", "S")
fakeit_address_street_suffix(); -- Street suffix (e.g., "Ave", "St")


Select
fakeit_address_city(), -- City name
fakeit_address_state(), -- State name
fakeit_address_state_abr(), -- State abbreviation
fakeit_address_zip(); -- ZIP/postal code

Select
fakeit_address_country(), -- Country name
fakeit_address_country_abr(), -- Country abbreviation
fakeit_address_latitude(), -- Random latitude
fakeit_address_longitude(); -- Random longitude

Select
fakeit_address_latitude_in_range(0, 66), -- Latitude within range
fakeit_address_longitude_in_range(0, 120); -- Longitude within range


-------------------
--Name Functions
-------------------
Select
fakeit_name_first(), -- First name
fakeit_name_last(), -- Last name
fakeit_name_full(), -- Full name (first + last)
fakeit_name_prefix(), -- Name prefix (e.g., "Mr.", "Mrs.")
fakeit_name_suffix(); -- Name suffix (e.g., "Jr.", "Sr.")


-------------------
--Contact Functions
-------------------
Select
fakeit_contact_email(), -- Email address
fakeit_contact_phone(), -- Phone number (unformatted)
fakeit_contact_phone_formatted(); -- Phone number (formatted)


-------------------
--Company Functions
-------------------
Select
fakeit_company_company(), -- Company name
fakeit_company_company_suffix(), -- Company suffix (e.g., "Inc", "LLC")
fakeit_company_buzzword(), -- Business buzzword
fakeit_company_bs(); -- Business BS phrase


-------------------
--Internet Functions
--------------------
Select
fakeit_internet_ipv4_address(), -- IPv4 address
fakeit_internet_ipv6_address(), -- IPv6 address
fakeit_internet_domain_name(), -- Domain name
fakeit_internet_domain_suffix(), -- Domain suffix (e.g., ".com", ".org")
fakeit_internet_username(), -- Username
fakeit_internet_mac_address(), -- MAC address
fakeit_internet_http_method(); -- HTTP method (GET, POST, etc.)


----------------
--UUID Functions
----------------
Select
fakeit_uuid_v1(), -- UUID version 1 (timestamp-based)
fakeit_uuid_v4(); -- UUID version 4 (random)

-------------------
--Animal Functions
-------------------
Select
fakeit_animal_pet_name(), -- Pet name
fakeit_animal_animal(), -- Random animal
fakeit_animal_farm(), -- Farm animal
fakeit_animal_cat(), -- Cat breed
fakeit_animal_dog(); -- Dog breed

----------------
--Beer Functions
----------------
Select
fakeit_beer_name(), -- Beer name
fakeit_beer_style(), -- Beer style
fakeit_beer_hop(), -- Hop variety
fakeit_beer_yeast(), -- Yeast type
fakeit_beer_malt(), -- Malt type
fakeit_beer_ibu(), -- IBU (International Bitterness Units)
fakeit_beer_alcohol(), -- Alcohol percentage
fakeit_beer_blg(); -- Degrees Blg (Balling)

-----------------
--Color Functions
-----------------
Select
fakeit_color_full(), -- Full color name
fakeit_color_hex(), -- Hex color code
fakeit_color_safe(), -- Web-safe color
fakeit_color_rgb(); -- RGB color array

--------------------
--Currency Functions
--------------------
Select
fakeit_currency_short(), -- Currency code (e.g., "USD")
fakeit_currency_long(), -- Currency name (e.g., "US Dollar")
fakeit_currency_price(); -- Random price


--------------------
--DateTime Functions
--------------------
Select
fakeit_datetime_month(), -- Month name
fakeit_datetime_day(), -- Day number
fakeit_datetime_week_day(), -- Weekday name
fakeit_datetime_year(), -- Year
fakeit_datetime_hour(), -- Hour
fakeit_datetime_minute(), -- Minute
fakeit_datetime_second(), -- Second
fakeit_datetime_nanosecond(), -- Nanosecond
fakeit_datetime_timezone(), -- Timezone name
fakeit_datetime_timezone_full(), -- Full timezone name
fakeit_datetime_timezone_abv(), -- Timezone abbreviation
fakeit_datetime_timezone_offset(), -- Timezone offset
fakeit_datetime_date(); -- Random date


----------------
--File Functions
----------------
Select
fakeit_file_extension(), -- File extension
fakeit_file_mime_type(); -- MIME type


------------------
--Hacker Functions
------------------
Select
fakeit_hacker_phrase(), -- Hacker phrase
fakeit_hacker_abbreviation(), -- Tech abbreviation
fakeit_hacker_adjective(), -- Tech adjective
fakeit_hacker_noun(), -- Tech noun
fakeit_hacker_verb(), -- Tech verb
fakeit_hacker_ingverb(); -- Tech verb (present participle)


-------------------
--Hipster Functions
-------------------
Select
fakeit_hipster_word(), -- Hipster word
fakeit_hipster_sentence(), -- Hipster sentence
fakeit_hipster_paragraph(); -- Hipster paragraph

-----------------
--Image Functions
-----------------
Select
fakeit_image_url(); -- Random image URL


---------------
--Job Functions
---------------
select 
fakeit_job_title(), 
fakeit_job_descriptor(), 
fakeit_job_level();

--------------------
--Language Functions
--------------------
select
fakeit_language_random(), -- Random language
fakeit_language_abbreviation(), -- Language abbreviation
fakeit_language_programming(); -- Programming language


---------------------
--Log Level Functions
---------------------
select
fakeit_log_level_general(), -- General log level
fakeit_log_level_syslog(), -- Syslog level
fakeit_log_level_apache(); -- Apache log level

--------------------
--Password Functions
--------------------
select
fakeit_password_generate(); -- Random password

-------------------
--Payment Functions
-------------------
select
fakeit_payment_credit_card_type(), -- Credit card type
fakeit_payment_credit_card_number(), -- Credit card number
fakeit_payment_credit_card_exp(), -- Expiration date
fakeit_payment_credit_card_cvv(), -- CVV code
fakeit_payment_credit_card_luhn_number(); -- Luhn--valid number


------------------
--Person Functions
------------------
select
fakeit_person_ssn(), -- Social Security Number
fakeit_person_gender(); -- Gender

-----------------------
--Status Code Functions
-----------------------
select
fakeit_status_code_simple(), -- Simple HTTP status code
fakeit_status_code_general(); -- General HTTP status code


----------------------
--User Agent Functions
----------------------
select
fakeit_user_agent_chrome(), -- Chrome user agent
fakeit_user_agent_firefox(), -- Firefox user agent
fakeit_user_agent_safari(), -- Safari user agent
fakeit_user_agent_opera(), -- Opera user agent
fakeit_user_agent_random_platform(), -- Random platform
fakeit_user_agent_linux_platform_token(), -- Linux platform token
fakeit_user_agent_mac_platform_token(), -- Mac platform token
fakeit_user_agent_windows_platform_token(); -- Windows platform token


-------------------
--Vehicle Functions
-------------------
select
fakeit_vehicle_vehicle_type(), -- Vehicle type
fakeit_vehicle_car_maker(), -- Car manufacturer
fakeit_vehicle_car_model(), -- Car model
fakeit_vehicle_fuel(), -- Fuel type
fakeit_vehicle_transmission_gear(); -- Transmission type


-----------------
--Words Functions
-----------------
select
fakeit_words_word(), -- Random word
fakeit_words_sentence(), -- Random sentence
fakeit_words_paragraph(), -- Random paragraph
fakeit_words_question(), -- Random question
fakeit_words_quote(); -- Random quote


-------------------
--Boolean Functions
-------------------
select
fakeit_bool(); -- Random boolean

---------------------
--Generator Functions
---------------------
select
fakeit_generator_generate(); -- Custom pattern generator


----------------
--Usage Examples
----------------

--Generate Test Users
---------------------
SELECT
    row_number() OVER () as id,
    fakeit_name_full() as name,
    fakeit_contact_email() as email,
    fakeit_contact_phone_formatted() as phone,
    fakeit_address_city() as city,
    fakeit_address_state() as state
FROM generate_series(1, 10),


----------------------------
--Generate E-commerce Orders
----------------------------
SELECT
    fakeit_uuid_v4() as order_id,
    fakeit_name_full() as customer_name,
    fakeit_company_company() as vendor,
    fakeit_currency_price() as amount,
    fakeit_payment_credit_card_type() as payment_method,
    fakeit_datetime_date() as order_date
FROM generate_series(1, 10);


----------------------
--Generate Log Entries
----------------------
SELECT
    fakeit_datetime_date() as timestamp,
    fakeit_internet_ipv4_address() as ip_address,
    fakeit_log_level_apache() as log_level,
    fakeit_internet_http_method() as http_method,
    fakeit_status_code_general() as status_code,
    fakeit_user_agent_chrome() as user_agent
FROM generate_series(1, 10);


-----------------------
--Generate GeoJSON Data
-----------------------
SELECT json_object(
    'type', 'Feature',
    'geometry', json_object(
        'type', 'Point',
        'coordinates', json_array(
            fakeit_address_longitude(),
            fakeit_address_latitude()
        )
    ),
    'properties', json_object(
        'name', fakeit_name_full(),
        'city', fakeit_address_city(),
        'country', fakeit_address_country()
    )
) as geojson
FROM generate_series(1, 50)
LIMIT 5;


---------------------------  END -----------------------------
