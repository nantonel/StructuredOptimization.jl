export Reshape

immutable Reshape{N,M,C<:AbstractArray,D<:AbstractArray,L<:LinearOperator} <: LinearOperator
	dim_out::NTuple{N,Int}
	dim_in::NTuple{M,Int}
	A::L
end

# Constructors

Reshape(L::LinearOperator, dim_out...) =
Reshape{length(dim_out),
	length(size(L,2)),
	Array{codomainType(L),length(dim_out)},
	Array{domainType(L),ndims(L,2)},
	typeof(L)}( dim_out, size(L,2), L)

# Mappings

function A_mul_B!{N,M,C,D,T}(y::C, L::Reshape{N,M,C,D,T}, b::D)
	y_res = reshape(y,size(L.A,1))
	b_res = reshape(b,size(L.A,2))
	A_mul_B!(y_res, L.A, b_res)
end

function Ac_mul_B!{N,M,C,D,T}(y::D, L::Reshape{N,M,C,D,T}, b::C)
	y_res = reshape(y,size(L.A,2))
	b_res = reshape(b,size(L.A,1))
	Ac_mul_B!(y_res, L.A, b_res)
end

# Properties

size(L::Reshape) = (L.dim_out, L.dim_in)

  domainType(  L::Reshape) =   domainType(L.A)
codomainType(  L::Reshape) = codomainType(L.A)

is_diagonal(    L::Reshape) = is_diagonal(L.A)
is_gram_diagonal(L::Reshape) = is_gram_diagonal(L.A)
is_invertible(  L::Reshape) = is_invertible(L.A)

fun_name(L::Reshape) = "Reshaped "*fun_name(L.A)