# CivicVoice

**A Platform for Civic Engagement and Accountability**

CivicVoice is a secure mobile and web platform that lets citizens report governance issues anonymously while maintaining complete privacy protection. Built specifically for Sub-Saharan Africa, it bridges the gap between citizens and government institutions through verified reporting and transparent public dashboards.

## What We Built

We created CivicVoice to solve a real problem: people want to report corruption, mismanagement, and abuse of power, but they're afraid of retaliation. Our platform gives them a safe way to speak up while ensuring their reports actually make a difference.

The app lets anyone submit reports about governance issues without creating accounts or revealing their identity. NGO moderators then verify these reports, and approved ones appear on public dashboards where everyone can see what's happening in their communities.

## Demo and Links

- **Live Demo**: [Watch on YouTube](https://youtu.be/IMR5HdwIiLE)
- **Figma Prototype**: [View Interactive Design](https://www.figma.com/design/s6KKvBnSWNwdVqOLiW4NVn/CIVICVOICE-APP?node-id=142-4&t=twaCXFa9wJHqS0AO-1)
- **Source Code**: [GitHub Repository](https://github.com/dzuokumor/Civic-voice.git)

## Key Features

### For Citizens
- **Anonymous reporting** - Submit reports without any registration or personal information
- **Issue tracking** - Get a unique reference code to check your report's progress
- **Multiple categories** - Report bribery, abuse, misuse of funds, and other governance issues
- **File attachments** - Include photos, documents, or other evidence
- **Location mapping** - Pin exact locations while keeping your own location private
- **Multi-language support** - Available in English, French, Kinyarwanda, and Kiswahili

### For Moderators
- **Secure verification** - Review and validate reports through a protected dashboard
- **Collaboration tools** - Work with field staff and other moderators securely
- **Quality assurance** - Senior moderators can review decisions before publication
- **Performance tracking** - Monitor verification times and accuracy rates

### For Everyone
- **Public dashboards** - Explore verified reports through interactive maps and charts
- **Data filtering** - Sort by location, issue type, date, and other criteria
- **Trend analysis** - See patterns in governance issues over time
- **Mobile responsive** - Works perfectly on phones, tablets, and computers

## How It Works

1. **Report Submission**: Citizens fill out a simple form describing the issue, optionally add location and files, then submit anonymously
2. **Verification Process**: Trained NGO moderators review reports, investigate claims, and approve or reject submissions
3. **Public Access**: Approved reports appear on public dashboards with identifying information removed
4. **Data Insights**: Researchers and policymakers can access anonymized data to understand governance trends

## Technology Stack

We built CivicVoice using modern, proven technologies:

**Mobile App**
- Flutter with Dart for cross-platform development
- SQLite for local data storage
- BLoC pattern for clean state management

**Backend Services**
- FastAPI for secure, fast API endpoints
- JWT tokens for moderator authentication
- Automated data validation and sanitization

**Security & Privacy**
- Military-grade encryption for all data
- Advanced anonymization techniques
- Zero personal information storage
- Secure file handling with metadata removal

**Infrastructure**
- Cloud deployment ready
- Microservices architecture
- Automated testing and quality assurance

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio or VS Code
- Git

### Installation

1. Clone the repository:
```bash
git clone https://github.com/dzuokumor/Civic-voice.git
cd Civic-voice
```

2. Install dependencies:
```bash
flutter pub get
```

3. Set up the database:
```bash
# Database setup instructions will be provided in setup docs
```

4. Configure environment variables:
```bash
# Copy example config and update with your settings
cp .env.example .env
```

5. Run the app:
```bash
flutter run
```

## Project Structure

```
CivicVoice/
├── lib/
│   ├── blocs/          # State management (BLoC pattern)
│   ├── models/         # Data models
│   ├── screens/        # UI screens
│   ├── services/       # API and database services
│   ├── utils/          # Helper functions
│   └── widgets/        # Reusable UI components
├── assets/
│   ├── images/         # App images and icons
│   └── translations/   # Language files
├── test/               # Unit and widget tests
└── docs/               # Documentation
```

## User Personas

**Alice - The Concerned Citizen**
A 28-year-old government worker who sees issues but fears speaking up through official channels. She needs complete anonymity but wants to know her report made a difference.

**David - The NGO Moderator** 
A 35-year-old program manager at a transparency organization. He needs efficient tools to verify reports quickly while maintaining high standards for accuracy.

**Elyse - The Policy Researcher**
A 32-year-old data analyst who needs access to governance data for research. She requires comprehensive, anonymized datasets with clear methodology documentation.

## Development Process

We used Agile methodology with two-week sprints, daily standups, and continuous stakeholder feedback. Our team collaborated using Google Workspace, Figma for design, and WhatsApp for quick coordination.

### Team Roles
- **Elyse Marie Uyiringiye**: Team Leader & Project Manager
- **John Kwizera**: Research & Design Coordinator  
- **David Fechukwu Zuokumor**: Systems Analyst & Designer
- **John Obure**: Research Lead & UI Designer
- **Uwimana Chantal**: Documentation & Design Specialist

## Testing

We implemented comprehensive testing covering:
- Unit tests for all business logic
- Integration tests for API endpoints
- End-to-end testing for complete user workflows
- Security testing and penetration testing
- Accessibility testing with real users
- Cross-platform compatibility testing

## Privacy and Security

Privacy isn't just a feature for us - it's the foundation of everything we built. Here's how we protect users:

- **Zero personal data collection** - We literally cannot identify who submitted what
- **Advanced anonymization** - Reports are processed to remove any identifying patterns
- **Secure file handling** - Photos and documents have metadata stripped automatically  
- **Encrypted everything** - All data is encrypted both in transit and at rest
- **Geographic clustering** - Locations are grouped to prevent pinpointing exact addresses
- **Session security** - Temporary tokens expire quickly with no permanent tracking

## Market Opportunity

The civic engagement platform market is growing at 12.8% annually and is valued at $5.6 billion globally. In Sub-Saharan Africa, with 300 million potential users in urban areas and growing internet penetration, there's huge demand for platforms that let people safely report governance issues.

We're targeting the 45-60 million digitally literate urban professionals who care about governance but currently have no safe way to report problems.

## Business Model

**Primary Revenue Streams:**
- Research data sales to academics and policy organizations ($500-2,000 per dataset)
- NGO partnership fees for verification services ($25,000-100,000 annually)
- Government consulting for transparency initiatives ($100,000-500,000 per project)
- Premium features for professional users

**Sustainability Approach:**
We designed CivicVoice to be financially sustainable while keeping core features free for citizens. Revenue from data sales and partnerships funds platform operations and expansion.

## Roadmap

**Next 6 months:**
- Launch in Kenya, Uganda, and Tanzania
- Add offline functionality for areas with poor connectivity  
- Implement advanced analytics and machine learning for pattern detection
- Build mobile apps for iOS and Android

**Next 1-2 years:**
- Expand to West African francophone countries
- Add blockchain verification for enhanced trust
- Develop AI-powered content analysis to help moderators
- Create real-time collaboration tools

**Long-term vision:**
- Scale across Africa with local partnerships
- Add advanced privacy technologies like zero-knowledge proofs
- Build a comprehensive civic engagement ecosystem
- Measure and demonstrate real policy impact

## Contributing

We welcome contributions! Whether you're a developer, designer, researcher, or civic engagement expert, there are ways to help:

1. **Code Contributions**: Check our issues tab for bugs and feature requests
2. **Design Help**: Improve accessibility and user experience
3. **Testing**: Help us test across different devices and networks
4. **Documentation**: Improve setup guides and user documentation
5. **Translation**: Help us add more local languages

Please read our contribution guidelines before submitting pull requests.

## Security Reporting

If you discover security vulnerabilities, please report them responsibly:
- Email: security@civicvoice.org (we'll set this up)
- Include detailed steps to reproduce
- Allow us 90 days to address issues before public disclosure

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

Special thanks to:
- **Aaron Izang** - Our facilitator at African Leadership University
- **Transparency International** - For inspiration and best practices
- **Our user testers** - Citizens, NGO workers, and researchers who provided invaluable feedback
- **Open source community** - For the amazing tools that made this possible

## Contact and Support

- **Project Team**: civicvoice.team@gmail.com (placeholder)
- **Technical Issues**: Use GitHub Issues for bug reports
- **Partnership Inquiries**: partnerships@civicvoice.org (placeholder)
- **General Questions**: hello@civicvoice.org (placeholder)

## Impact Goals

We built CivicVoice because we believe technology can make governance more transparent and accountable. Our goal is to:
- Reduce fear of reporting governance issues
- Increase citizen participation in accountability processes  
- Provide policymakers with better data for decision-making
- Strengthen democratic institutions across Africa

Every anonymous report submitted, every issue verified, and every corrupt practice exposed through our platform brings us closer to more accountable governance.

---

*CivicVoice was developed as part of the Mobile Application Development course at African Leadership University, Kigali, Rwanda (June-July 2025). The project represents our commitment to using technology for social good and strengthening democratic institutions across Africa.*
