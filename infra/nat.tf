
resource "aws_eip" "nat" {
  vpc = true
  
  tags = merge(var.default_tags,{
      Name = "nat"
  })
}



resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.eks-public-us-east-1a.id

  tags = merge(var.default_tags,{
      Name = "nat-eks-public-us-east-1a"
  })

  depends_on = [
    aws_internet_gateway.igw
  ]
}