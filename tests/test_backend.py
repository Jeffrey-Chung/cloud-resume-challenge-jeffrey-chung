import unittest
import boto3

'''
All unit tests for the backend infrastructure of the Cloud Resume Challenge
This script tests:
- Whether the lambda role is created
- Whether the lambda policy is created
- Whether the lambda function is created
- Whether the DynamoDB table is created
'''

# This function tests whether the lambda function is created
# Parameter: name of the lambda function
def lambda_function_created(function_name):
    lambda_function = boto3.client('lambda')
    response = lambda_function.get_function(function_name)
    if response["Configuration"]["FunctionName"] == function_name:
        return True
    
# This function tests whether the lambda IAM role is created
# Parameter: name of the lambda role
def lambda_role_created(lambda_role_name):
    lambda_role = boto3.resource('iam')
    response = lambda_role.get_role(lambda_role_name)
    if response['Role']['RoleName'] == lambda_role_name:
        return True

# This function tests whether the lambda policy is created and attached to the IAM role
# Parameter: name of the lambda policy and lambda role
def lambda_policy_created(lambda_role_name, lambda_policy_name):
    lambda_policy = boto3.resource('iam')
    response = lambda_policy.get_role_policy(lambda_role_name, lambda_policy_name)
    if response['PolicyName'] == lambda_policy_name:
        return True

# This function tests whether the DynamoDB table is created to store view count
# Parameter: name of the table
def table_created(table_name):
    dynamodb_table = boto3.resource('dynamodb').Table(table_name)
    return True

class TestBackEnd(unittest.TestCase):

    def test_table(self):
        self.assertTrue(table_created('jchung_dynamodb_table'))

    def test_lambda_role(self):
        self.assertTrue(lambda_role_created('jchung_lambda_role'))

    def test_lambda_policy(self):
        self.assertTrue(lambda_policy_created('jchung_lambda_role', 'aws_iam_policy_for_terraform_aws_lambda_role'))

    def test_lambda_function(self):
        self.assertTrue(lambda_function_created('jchung_lambda_api'))
    
   
if __name__ == '__main__':
    unittest.main()
