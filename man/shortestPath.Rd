\name{shortestPath}
\alias{shortestPath}
\title{Retrieve Shortest Paths and Weighted Shortest Paths}
\description{
Retrieve the shortest path between two nodes.
}
\usage{
shortestPath(fromNode, 
             relType, 
             toNode, 
             direction = "out", 
             max_depth = 1,
             cost_property = character())
}
\arguments{
  \item{fromNode}{A node object.}
  \item{relType}{The relationship type to traverse. Accepts a string.}
  \item{toNode}{A node object.}
  \item{direction}{The relationship direction to traverse. Accepts "in" or "out".}
  \item{max_depth}{The maximum depth of the path. Accepts an integer. This argument is ignored if \code{cost_property} is set.}
  \item{cost_property}{If retrieving a weighted shortest path, the name of the relationship property that contains the weights. Accepts a string.}
}
\value{
A path object. Returns NULL if a path is not found.
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")
clear(graph)

alice = createNode(graph, "Person", name = "Alice")
bob = createNode(graph, "Person", name = "Bob")
charles = createNode(graph, "Person", name = "Charles")
david = createNode(graph, "Person", name = "David")
elaine = createNode(graph, "Person", name = "Elaine")

r1 = createRel(alice, "KNOWS", bob, weight=1.5)
r2 = createRel(bob, "KNOWS", charles, weight=2)
r3 = createRel(bob, "KNOWS", david, weight=4)
r4 = createRel(charles, "KNOWS", david, weight=1)
r5 = createRel(alice, "KNOWS", elaine, weight=2)
r6 = createRel(elaine, "KNOWS", david, weight=2.5)

# The default max_depth of 1 will not find a path.
# There are no length-1 paths between alice and david.
p = shortestPath(alice, "KNOWS", david)
is.null(p)

# Set the max_depth to 4.
p = shortestPath(alice, "KNOWS", david, max_depth = 4)
p$length
n = nodes(p)
sapply(n, function(x) x$name)

# Setting the direction to "in" and traversing from alice to david will not find a path.
p = shortestPath(alice, "KNOWS", david, direction = "in", max_depth = 4)
is.null(p)

# Setting the direction to "in" and traversing from david to alice will find a path.
p = shortestPath(david, "KNOWS", alice, direction = "in", max_depth = 4)
p$length
n = nodes(p)
sapply(n, function(x) x$name)

# Find the weighted shortest path between Alice and David.
p = shortestPath(alice, "KNOWS", david, cost_property="weight")
p$length
p$weight
nodes(p)
}
\seealso{
\code{\link{allShortestPaths}}
}