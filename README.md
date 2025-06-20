# 📊 Gig Worker Retention Intelligence Hub

A comprehensive React-based dashboard for tracking and analyzing gig worker retention metrics across ICH and LFM channels with real-time data visualization.

## 🚀 Features

- 📈 **Interactive Data Visualization** - Upload CSV/Excel files to see comprehensive analytics
- 📊 **Real-time Charts** - Channel comparison, churn analysis, and retention trends
- 🎯 **Worker Journey Tracking** - End-to-end pipeline from selection to long-term retention
- 📱 **Responsive Design** - Works seamlessly on desktop, tablet, and mobile
- 🔍 **Advanced Analytics** - KPI tracking, attendance analysis, and predictive insights
- 🚨 **Alert System** - Critical retention alerts and action items
- 📥 **Export Functionality** - Download reports in Excel format

## 📁 Dashboard Sections

### 1. **Retention Overview**
- ICH Channel retention rates
- LFM Channel performance
- Overall retention metrics
- Churn risk alerts

### 2. **Worker Journey Pipeline**
- Complete funnel from selection to retention
- Stage-by-stage conversion rates
- Performance trends

### 3. **Analytics & Insights**
- Channel comparison charts
- Churn reason analysis
- Attendance deep dive
- KPI tracking

### 4. **Alerts & Actions**
- Critical retention alerts
- Performance warnings
- Success stories
- Action items

## 🛠️ Installation

1. **Clone the repository:**
```bash
git clone https://github.com/yourusername/retention-dashboard.git
cd retention-dashboard
```

2. **Install dependencies:**
```bash
npm install
```

3. **Start development server:**
```bash
npm start
```

4. **Build for production:**
```bash
npm run build
```

## 🚀 Deployment

### Quick Deployment
```bash
chmod +x deploy.sh
sudo ./deploy.sh
```

### Manual Deployment
```bash
npm run build
sudo mkdir -p /var/www/retention
sudo cp -r build/* /var/www/retention/
sudo chown -R www-data:www-data /var/www/retention
```

## 📊 Data Format

### Expected Excel/CSV Sheets:

#### 1. **retention_metrics**
```csv
channel,retention_rate,period,workers_count
ICH,87.3,30_day,2847
LFM,92.1,30_day,1456
```

#### 2. **channel_performance**
```csv
channel,active_workers,retention_rate,churn_rate,avg_tenure
ICH,2847,87.3,12.7,118
LFM,1456,92.1,7.9,142
```

#### 3. **churn_analysis**
```csv
reason,percentage,worker_count
Better Opportunity,34,156
Salary Issues,28,128
Work-Life Balance,19,87
```

#### 4. **worker_journey**
```csv
stage,count,percentage
Selected,4623,100
Offers Accepted,4387,94.9
Workers Placed,4303,98.1
```

#### 5. **attendance_data**
```csv
channel,daily_attendance,weekly_consistency,absent_today
ICH,93.7,89.2,234
LFM,95.8,93.4,87
```

#### 6. **alerts**
```csv
severity,title,description
critical,High Churn Risk,234 food delivery workers showing signs of disengagement
warning,Housing Capacity Alert,Mumbai Nest at 97% occupancy
```

## 🔧 Configuration

### Environment Variables
Create a `.env` file in the root directory:
```env
REACT_APP_API_URL=your_api_url_here
REACT_APP_DASHBOARD_TITLE=Retention Intelligence Hub
```

### Nginx Configuration
The dashboard deploys to `/retention` path. Update your nginx config:
```nginx
location /retention {
    alias /var/www/retention;
    try_files $uri $uri/ /retention/index.html;
}
```

## 📱 Dashboard URLs

After deployment, access dashboards at:
- **Retention Dashboard**: `http://your-server-ip/retention/`
- **LFM Dashboard**: `http://your-server-ip/lfm/`
- **Enterprise Dashboard**: `http://your-server-ip/enterprise/`
- **INTRA Dashboard**: `http://your-server-ip/intra/`

## 🔄 Updates

### Quick Update
```bash
sudo /usr/local/bin/update-retention-dashboard
```

### Manual Update
```bash
git pull
npm install
npm run build
sudo rm -rf /var/www/retention/*
sudo cp -r build/* /var/www/retention/
sudo chown -R www-data:www-data /var/www/retention
```

## 🛠️ Built With

- **React 18** - Frontend framework
- **Recharts** - Data visualization
- **Tailwind CSS** - Styling framework
- **Lucide React** - Icon library
- **Papa Parse** - CSV parsing
- **SheetJS** - Excel file processing

## 📊 Features in Detail

### Interactive Charts
- **Line Charts** - Channel retention comparison over time
- **Pie Charts** - Churn reason breakdown
- **Bar Charts** - Monthly retention trends
- **Funnel Charts** - Worker journey visualization

### Real-time Metrics
- Overall retention rates
- Channel-specific performance
- Attendance tracking
- Satisfaction scores
- Tenure analysis

### Alert System
- Critical churn risk alerts
- Capacity warnings
- Performance notifications
- Success story highlights

## 🔒 Security

- CORS headers configured
- XSS protection enabled
- Content type validation
- Secure file upload handling

## 📈 Performance

- Lazy loading for charts
- Optimized bundle size
- Efficient data processing
- Responsive design

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 📞 Support

For support, email support@yourcompany.com or create an issue in the repository.

## 🎯 Roadmap

- [ ] Real-time data integration
- [ ] Advanced predictive analytics
- [ ] Mobile app companion
- [ ] API integration
- [ ] Automated reporting
- [ ] Custom dashboard builder

---

**Built with ❤️ for better gig worker retention insights**# Retention-1
