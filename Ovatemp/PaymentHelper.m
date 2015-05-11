//
//  PaymentHelper.m
//  Ovatemp
//
//  Created by Daniel Lozano on 5/11/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "PaymentHelper.h"

#import <AddressBook/AddressBook.h>

@implementation PaymentHelper

#pragma mark - Getting info from payment

+ (NSString *)emailForPayment:(PKPayment *)payment
{
    ABMultiValueRef emailValue = ABRecordCopyValue(payment.shippingAddress, kABPersonEmailProperty);
    NSDictionary *email = (__bridge_transfer NSDictionary *) ABMultiValueCopyValueAtIndex(emailValue, 0);
    return [NSString stringWithFormat: @"%@", email];
}

+ (NSString *)phoneForPayment:(PKPayment *)payment
{
    ABMultiValueRef phoneValue = ABRecordCopyValue(payment.shippingAddress, kABPersonPhoneProperty);
    NSDictionary *phone = (__bridge_transfer NSDictionary *) ABMultiValueCopyValueAtIndex(phoneValue, 0);
    return [NSString stringWithFormat: @"%@", phone];
}

+ (NSString *)fullNameForPayment:(PKPayment *)payment
{
    ABMultiValueRef firstNameValue = ABRecordCopyValue(payment.shippingAddress, kABPersonFirstNameProperty);
    ABMultiValueRef lastNameValue = ABRecordCopyValue(payment.shippingAddress, kABPersonLastNameProperty);
    
    return [NSString stringWithFormat: @"%@ %@", firstNameValue, lastNameValue];
}

+ (NSString *)shippingAddressForPayment:(PKPayment *)payment
{
    ABMultiValueRef addressMultiValue = ABRecordCopyValue(payment.shippingAddress, kABPersonAddressProperty);
    NSDictionary *addressDict = (__bridge_transfer NSDictionary *) ABMultiValueCopyValueAtIndex(addressMultiValue, 0);
    
    return [NSString stringWithFormat: @"%@. %@, %@, %@. %@",
            addressDict[@"Street"], addressDict[@"City"],addressDict[@"Country"],addressDict[@"State"], addressDict[@"ZIP"]];
    
}

#pragma mark - Validating info from payment

+ (BOOL)validEmailForPayment:(PKPayment *)payment
{
    return [self isValidEmail: [self emailForPayment: payment]];
}

+ (BOOL)validPhoneForPayment:(PKPayment *)payment
{
    return [self isValidPhoneNumber: [self phoneForPayment: payment]];
}

+ (BOOL)validFullNameForpayment:(PKPayment *)payment
{
    ABMultiValueRef firstNameValue = ABRecordCopyValue(payment.shippingAddress, kABPersonFirstNameProperty);
    ABMultiValueRef lastNameValue = ABRecordCopyValue(payment.shippingAddress, kABPersonLastNameProperty);
    NSString *firstName = [NSString stringWithFormat: @"%@", firstNameValue];
    NSString *lastName = [NSString stringWithFormat: @"%@", lastNameValue];
    
    if (firstName.length == 0) {
        return NO;
    }
    
    if (lastName.length == 0) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)validShippingAddressForPayment:(PKPayment *)payment
{
    ABMultiValueRef addressMultiValue = ABRecordCopyValue(payment.shippingAddress, kABPersonAddressProperty);
    NSDictionary *addressDict = (__bridge_transfer NSDictionary *) ABMultiValueCopyValueAtIndex(addressMultiValue, 0);

    NSString *street = addressDict[@"Street"];
    NSString *city = addressDict[@"City"];
    NSString *state = addressDict[@"State"];
    NSString *country = addressDict[@"Country"];
    NSString *zip = addressDict[@"ZIP"];
    
    return (street.length != 0 && city.length != 0 && state.length != 0 && country.length != 0 && zip.length != 0);
}

#pragma mark - Validation

+ (BOOL)isValidEmail:(NSString *)email
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject: email];
}

+ (BOOL)isValidPhoneNumber:(NSString *)phoneNumber
{
    NSError *error = NULL;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes: NSTextCheckingTypePhoneNumber error: &error];
    
    NSRange inputRange = NSMakeRange(0, [phoneNumber length]);
    NSArray *matches = [detector matchesInString: phoneNumber options:0 range:inputRange];
    
    // no match at all
    if ([matches count] == 0) {
        return NO;
    }
    
    // found match but we need to check if it matched the whole string
    NSTextCheckingResult *result = (NSTextCheckingResult *)[matches objectAtIndex:0];
    
    if ([result resultType] == NSTextCheckingTypePhoneNumber && result.range.location == inputRange.location && result.range.length == inputRange.length) {
        // it matched the whole string
        return YES;
    }
    else {
        // it only matched partial string
        return NO;
    }
}

@end
