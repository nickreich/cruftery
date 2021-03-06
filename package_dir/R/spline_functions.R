# Generic radial spline:
radial_spline <- function(x, f, knot_points, knot_weights, knot_scale) {
  if (length(x) == 1) {
    knot_contributions <- f(x=x, center=knot_points, scale=knot_scale)*knot_weights
    return(sum(knot_contributions))
  } else {
    return(sapply(x,radial_spline, f=f, knot_points=knot_points, knot_weights=knot_weights, knot_scale=knot_scale))
  }
}

# Generic radial spline specialized to Gaussian.
gaussian_spline <- function(x, knot_points, knot_weights, knot_scale) {
  f <- function(x, center, scale) dnorm(x=x, mean=center, sd=scale)
  return(radial_spline(x=x, f=f, knot_points=knot_points, knot_weights=knot_weights, knot_scale=knot_scale))
}

# Integral of Gaussian radial spline.

gaussian_spline_integral <- function(knot_points, knot_weights, knot_scale, a, b) {
  contributions <- mapply(
    FUN=function(point, weight, scale, a, b) {
      weight * (pnorm(q=b, mean=point, sd=scale) - pnorm(q=a, mean=point, sd=scale))
    },
    point = knot_points, weight = knot_weights,
    MoreArgs = list(scale=knot_scale, a=a, b=b)
  )
  return(sum(contributions))
}











