//
//  webservice.m
//  Fullfill
//
//  Created by Ramesh on 07/10/15.
//  Copyright (c) 2015 WePOP AR Research Lab. All rights reserved.
//

#import "webservice.h"

#define SERVICE_URL @"https://datesauce.com/"

@implementation webservice

-(void)executeWebserviceWithMethod:(NSString *)method withValues:(NSString *)values
{
    NSLog(@"REQ: %@",values);
    
    NSData *postData = [values dataUsingEncoding:NSUTF8StringEncoding];
    NSString *strURL = [SERVICE_URL stringByAppendingString:method];
    // NSString *strURL = [SERVICE_URL stringByAppendingFormat:@"%@%@",method,values];
    NSURL *requestURL = [NSURL URLWithString:strURL];
    
    
    // NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:requestURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:300];
    
    NSMutableURLRequest *req =[NSMutableURLRequest requestWithURL:requestURL];
    
    
    [req setHTTPMethod:@"POST"];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    [req setValue:postLength  forHTTPHeaderField:@"Content-Length"];
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setHTTPBody:postData];
    
    
    NSLog(@"%@",req);
    NSLog(@"%@",values);
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    
    if(conn)
    {
        receivedData = [[NSMutableData alloc] init];
        [conn start];
    }
    else
    {
        [self.delegate receivedErrorWithMessage:@"Cannot create connection."];
    }
    
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.delegate receivedErrorWithMessage:[error localizedDescription]];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *response;
    response = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    
    NSDictionary* json;
    json = [NSJSONSerialization JSONObjectWithData:receivedData
                                                         options:kNilOptions
                                                           error:&error];
    
    
    NSDictionary *values = [NSJSONSerialization JSONObjectWithData:receivedData options:0 error:&error];
    NSLog(@"%@", values);
    
    if(values)
    {
        if([self.delegate respondsToSelector:@selector(receivedResponse:fromWebservice:)])
        {
            [self.delegate receivedResponse:values fromWebservice:self];
        }
        else
        {
            [self.delegate receivedErrorWithMessage:[values valueForKey:@"Error"]];
        }
    }
    else
    {
        [self.delegate receivedErrorWithMessage:@"Please Try Again Later"];
    }
}


- (void) executeWebserviceWithMethod1:(NSString *) method withValues:(NSString *) values
{
    
    NSString *strURL =[NSString stringWithFormat:@"%@%@%@",SERVICE_URL,method,values];
    NSURL *requestURL = [NSURL URLWithString:strURL];
    
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:requestURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:300];
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    
    if(conn)
    {
        receivedData = [[NSMutableData alloc] init];
        [conn start];
    }
    else
    {
        [self.delegate receivedErrorWithMessage:@"Cannot create connection."];
    }
    
}
-(void)flightStatusMethod2:(NSString *)method
{
    NSString *strURL=method;
    NSURL *url=[[NSURL alloc]initWithString:strURL];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:300];
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    
    if(conn)
    {
        receivedData = [[NSMutableData alloc] init];
        [conn start];
    }
    else
    {
        [self.delegate receivedErrorWithMessage:@"Cannot create connection."];
    }
    
}


-(void) executeWebserviceWithMethodinImage:(NSString *)method withValues:(NSURLRequest *)values
{
    NSString *strURL = [SERVICE_URL stringByAppendingString:method];
    // NSString *strURL = [SERVICE_URL stringByAppendingFormat:@"%@%@",method,values];
    NSURL *requestURL;
    requestURL = [NSURL URLWithString:strURL];
    //
    //     NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:requestURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:300];
    //
    //    req=values;
    //
    
    //  NSLog(@"%@",req);
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:values delegate:self];
    
    if(conn)
    {
        receivedData = [[NSMutableData alloc] init];
        [conn start];
    }
    else
    {
        [self.delegate receivedErrorWithMessage:@"Cannot create connection."];
    }
    
}

- (void) executeWebserviceWithMethod2:(NSString *)method
{
    NSString *strURL=[SERVICE_URL stringByAppendingString:method];
    NSURL *url=[[NSURL alloc]initWithString:strURL];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:300];
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    
    if(conn)
    {
        receivedData = [[NSMutableData alloc] init];
        [conn start];
    }
    else
    {
        [self.delegate receivedErrorWithMessage:@"Cannot create connection."];
    }
    
}

@end
