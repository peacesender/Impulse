import dns from 'dns';

const ports = [80, 443];
const { hostname } = new URL(process.argv[2])

try {
  const addresses = await dns.promises.lookup(hostname, { all: true, family: 4 });
  for (const { address } of addresses) {
    ports.map(port => console.log(`${address}:${port}`))
  }
} catch {
  // ignore errors
}
