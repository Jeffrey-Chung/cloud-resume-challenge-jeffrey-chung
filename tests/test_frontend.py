import unittest
import boto3

'''
All unit tests for the frontend infrastructure of the Cloud Resume Challenge
This script tests:
- Whether the site bucket is created
- Whether the logging bucket is created
- Whether the cloudfront distribution is created
'''

# This function tests whether the S3 buckets are created
# Parameter: name of the bucket created
def bucket_created(bucket_name):
    s3 = boto3.client('s3')
    response = s3.list_buckets()
    for bucket in response['Buckets']:
        if bucket["Name"] == bucket_name:
            return True
        
# This function tests whether the cloudfront distro is created
def cloudfront_created():
    cloudfront = boto3.client('cloudfront')
    response = cloudfront.list_distributions()
    if response['DistributionList']['Quantity'] > 0:
        for distribution in response['DistributionList']['Items']:
            print(f"Distribution Id: {distribution['Id']}")
            return True

class TestFrontEnd(unittest.TestCase):

    def test_site_bucket(self):
        self.assertTrue(bucket_created('tf-aws-jchung-cloud-resume-site-bucket'))
    
    def test_logging_bucket(self):
        self.assertTrue(bucket_created('tf-aws-jchung-cloud-resume-logging-bucket'))

    def test_cloudfront(self):
        self.assertTrue(cloudfront_created())

if __name__ == '__main__':
    unittest.main()
