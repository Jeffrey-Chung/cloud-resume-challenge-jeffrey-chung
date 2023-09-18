import json
import boto3

# Get the dynamodb table from our existing infrastructure
dynamodb = boto3.resource('dynamodb')
table = dynamodb.table('jchung_dynamodb_table')

def lambda_handler(event, context):
   # Getting the item with count_id of 0
   response = table.get_item(Key={
      'count_id' : '0'
   })
   # Getting the count_num value and increase it by 1 every time someone views the site
   views = response['Item']['count_num']
   views = views + 1
   # Shows how many people viewed the site
   print(views)

   # Update dynamodb table with increased views
   response = table.put_item(Item={
      'count_id' : '1',
      'count_num' : views
   })
   return views

