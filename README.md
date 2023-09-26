# Cloud-Resume-Challenge-Jeffrey-Chung

<h3>Still in WIP</h3>

<h1>Docker (extra)</h1>

Command to use Dockerized website: `docker run -it --name portfolio_website -p 8080:80 3ku11/portfolio_website:latest`

How to build Docker Image: `docker build -t <DockerHub username>/portfolio_website:latest .`

Link of Dockerized website: `http://localhost:8080/`

<h1> Docker Compose (extra) </h1>

Also implemented Docker Compose to alternatively and locally host sites with Apache and Nginx servers.

Command to spin up containers: `docker-compose up -d`

Link of website on Apache server: `http://localhost:8082/`

Link of website on Nginx server: `http://localhost:8081/`

Command to disable containers: `docker-compose down`

<h1>2. HTML </h1>

Used ezcv portfolio website for this part, full repo <a href="https://github.com/Jeffrey-Chung/personal_github_page" target="_blank">here</a>

Challenge(s): See CSS section

<h1>3. CSS </h1>

Used ezcv portfolio website for this part, full repo <a href="https://github.com/Jeffrey-Chung/personal_github_page" target="_blank">here</a>

Challenge(s): Learning how to get my ezcv website to be able to be deployed via Docker and S3. A solution to this is to used the built website (built from the `ezcv build` command) to be deployed. This will generate some html, css and js files to load the entire website, hence a static website generator. 

<h1> 4. Static Website </h1>

All required folders and files for the website will be uploaded to an S3 bucket created via Terraform (with or without GitHub Actions). 

Challenge(s): Adding the different folders of my static website (i.e. css, js, etc.) to my bucket. I found <a href="https://stackoverflow.com/questions/57456167/uploading-multiple-files-in-aws-s3-from-terraform" target="_blank">this</a> from SudoHarris user to be a solution of mine and convert it to get the appropriate folders instead of my entire repository.

<h1> 5. HTTPS </h1>

I used AWS CloudFront that connects to the S3 website URL, ran via CI/CD with GitHub Actions and Terraform.

Challenge(s): The HTTPS website at one point was not accessible even though there were no errors to my configuration. The 
reason for that is my geographical restriction settings, which is blocking access to Australia. I changed the restriction to "none" and website is accessible. 

<h1> 6. DNS </h1>

<h1> 7. Javascript </h1>

I added a `counter.js` file to fetch the API to show the visitor counter. 

Challenge(s): The JSON file from the Lambda function didn't pass through correctly, as a result I always encounter parsing issues. I tried to use the dotenv library to pass the API link via GitHub Actions, but it has different importing errors once loaded the website. I fixed it by adding <b>await</b> on calling the function and awaiting the request.

<h1> 8. Database </h1>

I used AWS DynamoDB as my database to store all the view counts of my website. 

Challenge(s): Learning about hash keys and items for DynamoDB. Turns out in short, hash key is the equivalent of a primary key for my use case and instead of adding a secondary index for my view count, I need to create an item for it instead. 

<h1> 9. API </h1>

I used Lambda's function URL as the API to be communicated between the DynamoDB database and the website. A Lambda function is made to get the index of the DynamoDB table and increase the value corresponding to the index (0) each time it's reloaded.

Challenge(s): There was a main issue when accessing the database via boto3, for example a typo when calling the table from the DynamoDB resource and using `boto3.client` instead of `boto3.resource`. I fixed it by calling the table in one line by using something similar to this `boto3.resource(X).Table(Y)`.

<h1> 10. Python </h1>

I used Python to write the Lambda function as per `9. API`. 

Challenge(s): Same as 9.

<h1> 11. Tests </h1>

<h1> 12. Infrastructure as Code </h1>

Terraform is used as the IaC tool for this challenge. tfsec is also implemented to make sure that code quality is on par with best practices per every pull request.

<h1> 13. Version Control </h1>

This is my repo for the cloud resume challenge.

IDC is setup to be able to run GitHub Actions with AWS. Terraform deployment (fmt/init/plan/apply) is also conducted in the `deploy.yml` file. A similar `test.yml` is implemented for every PR to test the infrastructure to look out for any errors before merging to main.

Challenge(s): Configurations for the trusted policy made it difficult to assign the role via Github Actions and OIDC. Turns out that I need to assign my ARN for my identity provider to the `"Federated"` section. Also `StringEquals` must be assigned to my audience and `StringLike` to my repo.

<h1> 14. CI/CD (backend) </h1>

Different inputs can be selected to trigger the CI/CD for backend or frontend. In this case you can simply select `backend`, for the structure and `build` or `destroy` to build or destroy the infrastructure respectively. It is recommended to run the backend workflow first then frontend.

This workflow runs the infrastructure related to DynamoDB database and Lambda function for the API.

<h1> 15. CI/CD (frontend) </h1>

Different inputs can be selected to trigger the CI/CD for backend or frontend. In this case you can simply select `frontend`, for the structure and `build` or `destroy` to build or destroy the infrastructure respectively. It is recommended to run the backend workflow first then frontend.

This workflow runs the infrastructure related to the S3 buckets and Cloudfront to deploy the static website.


<h1> 16. Blog Post </h1>

Dimension by HTML5 UP
html5up.net | @ajlkn
Free for personal and commercial use under the CCA 3.0 license (html5up.net/license)


This is Dimension, a fun little one-pager with modal-ized (is that a word?) "pages"
and a cool depth effect (click on a menu item to see what I mean). Simple, fully
responsive, and kitted out with all the usual pre-styled elements you'd expect.
Hope you dig it 

Demo images* courtesy of Unsplash, a radtastic collection of CC0 (public domain) images
you can use for pretty much whatever.

(* = not included)

AJ
aj@lkn.io | @ajlkn


Credits:

	Demo Images:
		Unsplash (unsplash.com)

	Icons:
		Font Awesome (fontawesome.io)

	Other:
		jQuery (jquery.com)
		Responsive Tools (github.com/ajlkn/responsive-tools)
