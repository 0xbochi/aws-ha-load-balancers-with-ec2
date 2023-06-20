import boto3

session = boto3.Session(region_name='eu-west-1')

ec2 = session.resource('ec2')


instances = ec2.instances.filter(
    Filters=[{'Name': 'instance-state-name', 'Values': ['running']}])

for instance in instances:
    # Obtenir le tag Name de l'instance
    for tag in instance.tags:
        if 'Name' in tag['Key']:
            instance_name = tag['Value']
    print('EC2 Name: ' + instance_name)
    print('Public DNS: ' + instance.public_dns_name)
    print(f'ssh -i ~/.ssh/id_rsa ec2-user@{instance.public_dns_name} \n')