# Railway.app Deployment Guide

## Prerequisites
- GitHub account
- Railway.app account (sign up at https://railway.app)
- Your code pushed to a GitHub repository

## Step-by-Step Deployment

### Step 1: Prepare Your GitHub Repository

1. **Initialize Git (if not already done):**
   ```bash
   git init
   git add .
   git commit -m "Prepare for Railway deployment"
   ```

2. **Push to GitHub:**
   ```bash
   # Create a new repository on GitHub first, then:
   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
   git branch -M main
   git push -u origin main
   ```

### Step 2: Sign Up for Railway.app

1. Go to https://railway.app
2. Click "Login" and sign in with your GitHub account
3. Authorize Railway to access your GitHub repositories

### Step 3: Create a New Project

1. Click "New Project" on the Railway dashboard
2. Select "Deploy from GitHub repo"
3. Choose your hotel-management repository
4. Railway will automatically detect it's a Node.js project

### Step 4: Add PostgreSQL Database

1. In your Railway project, click "+ New"
2. Select "Database" → "PostgreSQL"
3. Railway will automatically create a PostgreSQL database
4. The `DATABASE_URL` environment variable will be automatically added to your service

### Step 5: Add RabbitMQ (CloudAMQP)

**Option A: Using CloudAMQP (Recommended - Free Tier)**

1. Go to https://www.cloudamqp.com/
2. Sign up for a free account
3. Create a new instance:
   - Select "Little Lemur" (Free plan)
   - Choose a region close to your Railway deployment
4. Copy the AMQP URL from the CloudAMQP dashboard
5. In Railway, go to your web service → "Variables" tab
6. Add new variable:
   - Key: `RABBITMQ_URL`
   - Value: `amqp://your-cloudamqp-url` (paste the URL from CloudAMQP)

**Option B: Add RabbitMQ in Railway (Uses Credit)**

1. In your Railway project, click "+ New"
2. Select "Template"
3. Search for "RabbitMQ" and add it
4. Copy the connection URL from RabbitMQ service variables
5. Add it to your web service as `RABBITMQ_URL`

### Step 6: Configure Environment Variables

In Railway, go to your web service → "Variables" tab and verify these are set:

```
DATABASE_URL=postgresql://... (automatically set by Railway)
RABBITMQ_URL=amqp://... (from CloudAMQP or Railway RabbitMQ)
PORT=3000 (optional, Railway sets this automatically)
```

### Step 7: Configure Build & Start Commands

Railway should auto-detect these, but verify in "Settings" → "Deploy":

- **Build Command:** `npm install && npm run build`
- **Start Command:** `npm run start:prod`

### Step 8: Run Database Migrations

After the first deployment, you need to push the Prisma schema:

1. In Railway dashboard, click on your web service
2. Go to "Settings" → "Networking"
3. Generate a domain (or use the provided one)
4. In Railway, go to "Settings" → "Raw Editor" and add this variable:
   ```
   DATABASE_URL=postgresql://... (copy from Variables tab)
   ```

5. Run migrations locally (pointing to Railway database):
   ```bash
   # Copy DATABASE_URL from Railway
   npx prisma migrate dev --name init
   # Or just push the schema
   npx prisma db push
   ```

**OR** Run migration directly in Railway:

1. Click on your service → "Settings" → "One-off Commands"
2. Run: `npx prisma db push`

### Step 9: Deploy

1. Railway automatically deploys when you push to GitHub
2. Monitor the deployment in the "Deployments" tab
3. Check logs for any errors

### Step 10: Test Your Deployment

1. Go to "Settings" → "Networking" in your Railway web service
2. Copy the public domain (e.g., `your-app.up.railway.app`)
3. Test your API:
   ```bash
   curl https://your-app.up.railway.app/api
   ```

## Common Issues & Solutions

### Issue 1: Database Connection Error
**Solution:** Make sure `DATABASE_URL` is set correctly. Railway automatically provides this for PostgreSQL.

### Issue 2: RabbitMQ Connection Failed
**Solution:**
- Check `RABBITMQ_URL` is set correctly
- Verify CloudAMQP instance is running
- Check the URL format: `amqp://username:password@host/vhost`

### Issue 3: Build Fails
**Solution:**
- Check build logs in Railway
- Verify all dependencies are in `package.json`
- Make sure `postinstall` script runs successfully

### Issue 4: App Crashes After Deploy
**Solution:**
- Check application logs in Railway dashboard
- Verify PORT is not hardcoded (use `process.env.PORT`)
- Make sure all environment variables are set

## Updating Your Deployment

1. Make changes to your code locally
2. Commit and push to GitHub:
   ```bash
   git add .
   git commit -m "Your update message"
   git push
   ```
3. Railway automatically redeploys

## Monitoring

- **Logs:** Click on your service → "Deployments" → Select deployment → "View Logs"
- **Metrics:** Available in the service dashboard
- **Health:** Railway provides automatic health checks

## Cost

Railway free tier includes:
- $5 free credit per month
- Should be sufficient for development and small projects
- PostgreSQL and web service included

CloudAMQP free tier:
- 1 million messages/month
- Perfect for development

## Next Steps

1. Set up a custom domain (in Railway Settings → Networking)
2. Add monitoring and logging
3. Set up automated backups for PostgreSQL
4. Configure CI/CD for automated testing before deployment

## Rollback

If something goes wrong:
1. Go to "Deployments" tab
2. Find a previous successful deployment
3. Click "..." → "Redeploy"

## Support

- Railway docs: https://docs.railway.app
- Railway Discord: https://discord.gg/railway
- CloudAMQP docs: https://www.cloudamqp.com/docs/
