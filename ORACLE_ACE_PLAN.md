# Oracle ACE Associate Promotion Plan

A roadmap to build Oracle Cloud projects using **only Always Free resources** to strengthen your Oracle ACE profile and promote from **ACE Associate → ACE Pro**.

## Oracle ACE Program Levels

| Level | Requirements |
|-------|-------------|
| **ACE Associate** | Active community contributions, blog posts, speaking, Oracle technology expertise |
| **ACE Pro** | 12+ months as ACE Associate, increased community impact, deeper technical contributions |
| **ACE Director** | Sustained high-impact contributions, thought leadership, community building |

## OCI Always Free Resources Available

| Service | Free Allocation |
|---------|----------------|
| **Compute (A1.Flex ARM)** | 4 OCPUs, 24GB RAM (can split into up to 4 VMs) |
| **Compute (E2.1.Micro AMD)** | 2 instances (1/8 OCPU, 1GB RAM each) |
| **Autonomous Database** | 2 instances (1 OCPU, 20GB each) |
| **MySQL HeatWave** | 1 standalone instance (50GB storage) |
| **NoSQL Database** | 133M reads/month, 133M writes/month, 25GB per table |
| **Object Storage** | 20GB |
| **Block Volume** | 200GB total |
| **Load Balancer** | 1 Flexible (10 Mbps) |
| **Network Load Balancer** | 1 instance |
| **VCN** | 2 Virtual Cloud Networks |
| **Vault** | 20 HSM key versions, 150 secrets |
| **Resource Manager (Terraform)** | 100 stacks, 2 concurrent jobs |
| **Monitoring** | 500M ingestion data points |
| **Logging** | 10GB/month |
| **Notifications** | 1M HTTPS/month, 1K email/month |
| **Email Delivery** | 3,000 emails/month |
| **APM** | 1,000 tracing events/hr |
| **Bastion** | Free (SSH jump host) |
| **Outbound Data Transfer** | 10TB/month |

---

## Project Plan: 6 Free-Tier OCI Projects

### Project 1: Autonomous Database Web App with APEX
**Difficulty:** Easy | **Time:** 1-2 days | **Blog-worthy:** Yes

**Resources Used:** Autonomous Database (free), APEX (built-in)

**What to Build:**
- Create an Always Free Autonomous Database (ATP)
- Build a web application using Oracle APEX (no-code/low-code)
- Example: Task tracker, inventory manager, or event registration app
- APEX is built into Autonomous DB — no compute needed

**Steps:**
1. Create Autonomous Database (Transaction Processing workload)
2. Access APEX workspace from the DB console
3. Build and deploy an APEX application
4. Write a blog post: "Building a Zero-Cost Web App with Oracle APEX on Always Free Tier"

**ACE Value:** Demonstrates Oracle DB + APEX skills, great for beginner-friendly content

---

### Project 2: Infrastructure as Code with OCI Resource Manager (Terraform)
**Difficulty:** Medium | **Time:** 2-3 days | **Blog-worthy:** Yes

**Resources Used:** Resource Manager (free), VCN, Compute

**What to Build:**
- Write Terraform configs to automate OCI infrastructure provisioning
- Deploy VCN + Subnet + Security List + Compute instance via Resource Manager
- Store Terraform state in OCI Object Storage
- Create reusable Terraform modules

**Steps:**
1. Convert `always_free_deploy.sh` into Terraform HCL
2. Create a Resource Manager Stack in OCI Console
3. Plan and Apply the stack
4. Write a blog post: "Automating OCI Always Free Infrastructure with Terraform and Resource Manager"

**ACE Value:** Shows IaC expertise, directly reusable by the community, great GitHub repo

---

### Project 3: MySQL HeatWave + Application Backend
**Difficulty:** Medium | **Time:** 2-3 days | **Blog-worthy:** Yes

**Resources Used:** MySQL HeatWave (free), Compute A1.Flex (free)

**What to Build:**
- Provision Always Free MySQL HeatWave DB System
- Deploy a REST API on A1.Flex (Python Flask/Go) connecting to MySQL
- Demonstrate CRUD operations
- Show HeatWave query acceleration

**Steps:**
1. Create MySQL HeatWave DB System (Always Free)
2. Launch A1.Flex compute instance (when capacity available)
3. Deploy a simple REST API application
4. Write a blog post: "Building a Free REST API with OCI MySQL HeatWave and ARM Compute"

**ACE Value:** Combines database + compute + application skills

---

### Project 4: NoSQL Database Serverless App
**Difficulty:** Medium | **Time:** 2-3 days | **Blog-worthy:** Yes

**Resources Used:** Oracle NoSQL Database (free), Autonomous DB (free)

**What to Build:**
- Create NoSQL tables for high-speed key-value operations
- Build a serverless-style app (e.g., URL shortener, IoT data store)
- Compare NoSQL vs Autonomous DB performance for different workloads

**Steps:**
1. Create NoSQL tables via OCI Console or CLI
2. Write a simple application using Oracle NoSQL SDK
3. Ingest sample data and run queries
4. Write a blog post: "When to Use Oracle NoSQL vs Autonomous DB — A Free Tier Comparison"

**ACE Value:** Shows breadth of Oracle DB knowledge, comparison content performs well

---

### Project 5: OCI Monitoring, Logging & Observability Stack
**Difficulty:** Medium-Hard | **Time:** 3-4 days | **Blog-worthy:** Yes

**Resources Used:** Monitoring (free), Logging (free), Notifications (free), APM (free), Connector Hub (free)

**What to Build:**
- Set up custom metrics and alarms for your Always Free compute instances
- Configure VCN Flow Logs for network audit
- Set up Notifications (email/HTTPS) for alarm triggers
- Use APM for application tracing
- Connect services with Connector Hub

**Steps:**
1. Enable Monitoring on existing compute instances
2. Create custom alarms (CPU > 80%, etc.)
3. Configure Logging service with VCN Flow Logs
4. Set up Notification topics and subscriptions
5. Wire everything with Connector Hub
6. Write a blog post: "Zero-Cost Observability on OCI: Monitoring, Logging, and Alerting with Always Free Tier"

**ACE Value:** Observability is a hot topic, demonstrates ops/SRE skills

---

### Project 6: Secure Architecture with Bastion, Vault & Private Networking
**Difficulty:** Hard | **Time:** 3-5 days | **Blog-worthy:** Yes

**Resources Used:** Bastion (free), Vault (free), VCN (free), Compute (free)

**What to Build:**
- Deploy compute instances in a private subnet (no public IP)
- Use OCI Bastion for secure SSH access
- Store secrets (DB passwords, API keys) in OCI Vault
- Retrieve secrets from applications at runtime
- Demonstrate zero-trust architecture patterns

**Steps:**
1. Create private subnet with no internet access
2. Deploy compute instance in private subnet
3. Create Bastion and establish SSH session
4. Create Vault and store secrets
5. Write application code that retrieves secrets from Vault
6. Write a blog post: "Building a Zero-Trust Architecture on OCI Always Free Tier"

**ACE Value:** Security is high-demand content, demonstrates enterprise architecture thinking

---

## ACE Associate → ACE Pro Promotion Strategy

### Month 1-3: Foundation
- [ ] Complete Projects 1 & 2 (APEX app + Terraform IaC)
- [ ] Publish 2 blog posts on Medium/Hashnode/personal blog
- [ ] Share projects on GitHub with good READMEs
- [ ] Present at 1 local meetup or virtual event
- [ ] Engage on Oracle Community forums (answer 10+ questions)

### Month 4-6: Growth
- [ ] Complete Projects 3 & 4 (MySQL HeatWave + NoSQL)
- [ ] Publish 2 more blog posts
- [ ] Submit a talk proposal to Oracle CloudWorld or Oracle DevLive
- [ ] Create a YouTube video or tutorial series
- [ ] Engage on Twitter/LinkedIn sharing Oracle content weekly

### Month 7-9: Depth
- [ ] Complete Projects 5 & 6 (Observability + Security)
- [ ] Publish 2 more blog posts (aim for 6+ total)
- [ ] Present at 2+ conferences/meetups
- [ ] Mentor 1-2 community members
- [ ] Contribute to Oracle documentation or open-source projects

### Month 10-12: Promotion Application
- [ ] Compile portfolio of all contributions (blogs, talks, repos, community answers)
- [ ] Gather community endorsements
- [ ] Apply for ACE Pro promotion with documented impact
- [ ] Total targets: 6+ blog posts, 3+ talks, 6+ GitHub repos, 50+ community answers

### Key Content Channels
- **Blog:** Medium, Hashnode, Dev.to, or personal blog
- **Code:** GitHub repos with clean READMEs and automation scripts
- **Talks:** Oracle CloudWorld, Oracle DevLive, CNCF meetups, local user groups
- **Social:** LinkedIn posts, Twitter/X threads about OCI
- **Community:** Oracle Forums, Stack Overflow (oracle-cloud tags)

---

## Quick Wins (Can Do Today, No Compute Needed)

These don't require A1.Flex capacity:

1. **Autonomous Database + APEX App** — Create in OCI Console immediately
2. **Resource Manager Terraform Stack** — Upload HCL, no compute needed
3. **NoSQL Database Tables** — Create via Console/CLI
4. **Object Storage Bucket** — Create and upload files
5. **Vault + Secrets** — Create encryption keys and secrets
6. **Monitoring Alarms + Notifications** — Set up even without instances

---

## Summary

| # | Project | Free Services Used | Can Do Now? |
|---|---------|-------------------|-------------|
| 1 | APEX Web App | Autonomous DB, APEX | Yes |
| 2 | Terraform IaC | Resource Manager, VCN | Yes |
| 3 | MySQL REST API | MySQL HeatWave, Compute | Partial (need A1) |
| 4 | NoSQL App | NoSQL Database | Yes |
| 5 | Observability Stack | Monitoring, Logging, APM | Yes |
| 6 | Secure Architecture | Bastion, Vault, VCN | Yes |

**Total cost: $0** — All projects use only Always Free resources.
