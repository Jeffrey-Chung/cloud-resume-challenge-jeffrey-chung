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
    s3 = boto3.resource('s3')
    response = s3.list_buckets()
    for bucket in response['Buckets']:
        if bucket["Name"] == bucket_name:
            return True
        
# This function tests whether the cloudfront distro is created
# Since the ID is unique every time, it will search via the cache policy ID
def cloudfront_created(cache_policy_id):
    cloudfront = boto3.resource('cloudfront')
    response = cloudfront.list_distributions_by_cache_policy_id(CachePolicyId=cache_policy_id)
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
        self.assertTrue(cloudfront_created('658327ea-f89d-4fab-a63d-7e88639e58f6'))

if __name__ == '__main__':
    unittest.main()
