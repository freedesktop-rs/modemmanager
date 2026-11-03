# Security Policy

## Supported Versions

We take security seriously and provide security updates for the latest version of modemmanager.
We strongly recommend keeping your modemmanager dependencies up to date.

## Reporting a Vulnerability

**Please do not report security vulnerabilities through public GitHub issues.**

If you discover a security vulnerability in modemmanager or any of the related crates, please report it privately by emailing
**akrm@cachebag.sh**.

Please include the following information in your report:

- A clear description of the vulnerability
- Steps to reproduce the issue
- Potential impact and attack scenarios
- Any suggested fixes or mitigations
- Your contact information for follow-up questions

### What constitutes a security vulnerability?

For modemmanager, security vulnerabilities may include but are not limited to:

- **Credential exposure**: Leaking SIM PINs/PUKs, bearer passwords, or other sensitive connection data through logs, errors, or memory
- **D-Bus injection**: Malicious D-Bus messages that could manipulate modem or bearer state
- **Denial of service**: Crashes, hangs, or resource exhaustion that prevent legitimate modem management
- **Information disclosure**: Exposing IMEI, ICCID, IMSI, or connection details to unauthorized processes
- **Input validation failures**: Improper handling of malformed APNs, PINs, or configuration data leading to undefined behavior
- **Race conditions**: Timing vulnerabilities in modem/bearer state management that could lead to security issues
- **Dependency vulnerabilities**: Security issues in upstream crates (zbus, etc.) that affect modemmanager

## Response Timeline

We are committed to responding to security reports promptly:

- **Acknowledgment**: We will acknowledge receipt of your vulnerability report within
  **24 hours**
- **Initial assessment**: We will provide an initial assessment of the report within
  **5 business days**
- **Regular updates**: We will provide progress updates at least every **7 days** until
  resolution
- **Resolution**: We aim to provide a fix or mitigation within **30 days** for critical
  vulnerabilities

Response times may vary based on the complexity of the issue and availability of maintainers.

## Disclosure Policy

We follow a coordinated disclosure process:

1. **Private disclosure**: We will work with you to understand and validate the vulnerability
2. **Fix development**: We will develop and test a fix in a private repository if necessary
3. **Coordinated release**: We will coordinate the public disclosure with the release of a fix
4. **Public disclosure**: After a fix is available, we will publish a security advisory

We request that you:
- Give us reasonable time to address the vulnerability before making it public
- Avoid accessing or modifying data beyond what is necessary to demonstrate the vulnerability
- Act in good faith and avoid privacy violations or destructive behavior

## Security Advisories

Published security advisories will be available through:

- GitHub Security Advisories on the
  [modemmanager repository](https://github.com/freedesktop-rs/mmrs/security/advisories)
- [RustSec Advisory Database](https://rustsec.org/)
- Release notes and changelog entries

## Recognition

We appreciate the security research community's efforts to improve the security of modemmanager. With
your permission, we will acknowledge your contribution in:

- Security advisories
- Release notes
- Project documentation

If you prefer to remain anonymous, please let us know in your report.

## Scope

This security policy covers modemmanager.

## Additional Resources

- [Contributing Guidelines](CONTRIBUTING.md)
- [Rust Security Policy](https://www.rust-lang.org/policies/security)

Thank you for helping keep modemmanager and the Rust ecosystem secure!
