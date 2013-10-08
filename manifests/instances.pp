# Create all virtual hosts from hiera
class lianasofguyana::instances
{
  create_resources('apache::vhost', hiera('lianasofguyana', []))
}
