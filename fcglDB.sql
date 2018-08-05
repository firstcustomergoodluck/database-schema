CREATE DATABASE IF NOT EXISTS fcgl;

USE fcgl;

#The condition of an item (example: like new, very good, good...)
CREATE TABLE IF NOT EXISTS item_condition (
	item_condition_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    item_condition VARCHAR(20) NOT NULL,
    PRIMARY KEY (item_condition_id)
);

#Items that has ever been sold through our service
#The only field that will get contantly updated is the quantity
#Note: Might want to purge items that have not been sold in a while
#Question: Should we add a timestamp for when it was last sold?
CREATE TABLE IF NOT EXISTS item (
	item_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    item_price DOUBLE UNSIGNED NOT NULL,
    item_condition_id INT UNSIGNED NOT NULL,
    Item_sku VARCHAR(20),
    Item_quantity INT UNSIGNED,
    item_name VARCHAR(50) NOT NULL,
    item_description VARCHAR(100),
    PRIMARY KEY (item_id),
    FOREIGN KEY (item_condition_id) REFERENCES item_condition(item_condition_id)
);

#The e-comerce vendors where we will be selling our items (Amazon, Ebay...) 
CREATE TABLE IF NOT EXISTS vendor (
	vendor_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    vendor_name VARCHAR(30) NOT NULL,
    PRIMARY KEY (vendor_id)
);

#We don't need much information from the user because we will be using google/fb
CREATE TABLE IF NOT EXISTS user (
	user_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (user_id)
);

#Allows for a user to have multiple addresses
CREATE TABLE IF NOT EXISTS user_address(
	user_address_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id INT UNSIGNED NOT NULL,
    user_address VARCHAR (100) NOT NULL,
    user_zipcode INT NOT NULL,
    PRIMARY KEY (user_address_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id)
);

#Will hold the api_id given by the login providers we us (google, facebook..)
CREATE TABLE IF NOT EXISTS user_login (
	user_login_id  INT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id INT UNSIGNED NOT NULL,
    login_service_id INT UNSIGNED NOT NULL,
    #TODO: See how different the API id is for services, maybe we can add a symbol
    #at the end to differentiate (1434232-FB)... maybe we need another table for login-services
    api_id INT UNSIGNED NOT NULL UNIQUE, #hopefully It can be unique for each login-service 
    PRIMARY KEY(user_login_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id)
);

#Items posted on a given vendor
CREATE TABLE IF NOT EXISTS vendor_item (
	vendor_item_id INT UNSIGNED NOT NULL ,
    item_id INT UNSIGNED NOT NULL, 
    vendor_id INT UNSIGNED NOT NULL,
    PRIMARY KEY (vendor_item_id),
    FOREIGN KEY (item_id) REFERENCES item(item_id),
    FOREIGN KEY (vendor_id) REFERENCES vendor(vendor_id)
);

#An item a user has posted through our service
CREATE TABLE IF NOT EXISTS user_item (
	user_item_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    item_id INT UNSIGNED NOT NULL, #foreign key
    user_id INT UNSIGNED NOT NULL, #foreign key
    vendor_item_id INT UNSIGNED NOT NULL, #foreign key
    post_time INT UNSIGNED NOT NULL,
    is_sold bool NOT NULL,
    user_item_description VARCHAR(100),
    user_item_quantity  INT UNSIGNED,
    PRIMARY KEY (user_item_id),
    FOREIGN KEY (item_id) REFERENCES item(item_id),    
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (vendor_item_id) REFERENCES vendor_item(vendor_item_id)
);