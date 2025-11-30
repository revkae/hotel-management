const { PrismaClient } = require('@prisma/client');

async function main() {
  const prisma = new PrismaClient();

  console.log('✅ Prisma Client initialized');

  // Test connection
  try {
    await prisma.$connect();
    console.log('✅ Database connection successful');

    // Test query
    const count = await prisma.user.count();
    console.log(`✅ Database query successful (${count} users found)`);

    await prisma.$disconnect();
    console.log('✅ Database disconnected');

    console.log('\n🎉 All systems operational!');
    console.log('\nYou can now:');
    console.log('  1. Start RabbitMQ: docker run -d --name rabbitmq -p 5672:5672 -p 15672:15672 rabbitmq:3-management');
    console.log('  2. Run the app: npm run start:dev');
    console.log('  3. Test APIs: Import Postman_Collection.json');

  } catch (error) {
    console.error('❌ Error:', error.message);
    process.exit(1);
  }
}

main();
