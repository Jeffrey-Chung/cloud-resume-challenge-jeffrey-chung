# Cloud-Resume-Challenge-Jeffrey-Chung

<h3>Still in WIP</h3>

<h1>Docker (extra)</h1>

Command to use Dockerized website: `docker run -it --name portfolio_website -p 8080:80 3ku11/portfolio_website:latest`

How to build Docker Image: `docker build -t <DockerHub username>/portfolio_website:latest .`

Link of Dockerized website: `http://localhost:8080/`


<h1>2. HTTP </h1>

Used ezcv portfolio website for this part, full repo <a href="https://github.com/Jeffrey-Chung/personal_github_page" target="_blank">here</a>

Challenge(s): See CSS section

<h1>3. CSS </h1>

Used ezcv portfolio website for this part, full repo <a href="https://github.com/Jeffrey-Chung/personal_github_page" target="_blank">here</a>

Challenge(s): Learning how to get my ezcv website to be able to be deployed via Docker and S3. A solution to this is to used the built website (built from the `ezcv build` command) to be deployed. This will generate some html, css and js files to load the entire website, hence a static website generator. 

<h1> 4. Static Website </h1>

All required folders and files for the website will be uploaded to an S3 bucket created via Terraform (with or without GitHub Actions). 

Challenge(s): Adding the different folders of my static website (i.e. css, js, etc.) to my bucket. I found <a href="https://stackoverflow.com/questions/57456167/uploading-multiple-files-in-aws-s3-from-terraform" target="_blank">this</a> from SudoHarris user to be a solution of mine and convert it to get the appropriate folders instead of my entire repository.

<h1> 5. HTTPS </h1>

<h1> 6. DNS </h1>

<h1> 7. Javascript </h1>

<h1> 8. Database </h1>

<h1> 9. API </h1>

<h1> 10. Python </h1>

<h1> 11. Tests </h1>

<h1> 12. Infrastructure as Code </h1>

Terraform is used as the IaC tool for this challenge. tfsec is also implemented to make sure that code quality is on par with best practices per every pull request.

<h1> 13. Version Control </h1>

This is my repo for the cloud resume challenge.

<h1> 14. CI/CD (backend) </h1>

<h1> 15. CI/CD (frontend) </h1>

OIDC is setup to be able to run GitHub Actions with AWS. Terraform deployment (fmt/init/plan/apply) is also conducted in the `deploy.yml` file.

Challenge(s): Configurations for the trusted policy made it difficult to assign the role via Github Actions and OIDC. Turns out that I need to assign my ARN for my identity provider to the `"Federated"` section. Also `StringEquals` must be assigned to my audience and `StringLike` to my repo.

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
