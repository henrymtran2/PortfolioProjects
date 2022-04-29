-- Cleaning Data in SQL Queries

Select *
From PortfolioProject.dbo.NashvilleHousing

-- Standardize Date Format

Select SaleDate2, CONVERT(Date, SaleDate)
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

Alter Table NashvilleHousing
Add SaleDate2 Date;

Update NashvilleHousing
SET SaleDate2 = Convert(Date, SaleDate)
 -------------------------------------------------------------------------------------------------
-- Populate Property Address Data

Select *
From PortfolioProject.dbo.NashvilleHousing
-- Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.propertyaddress, b.propertyaddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

 -------------------------------------------------------------------------------------------------

 -- Breaking out Address into Individual Columns (Address, City, State)

 Select PropertyAddress
 From PortfolioProject.dbo.NashvilleHousing

 SELECT
 SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
 , SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as City

 From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar (255);

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


Select *
From PortfolioProject.dbo.NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 3)
,PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 2)
,PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 1)
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 1)

 -------------------------------------------------------------------------------------------------
 -- Change Y and N to Yes and No in "Sold as Vacant" field

 -- Update Statement
 Select Distinct(SoldAsVacant), Count(SoldAsVacant)
 From PortfolioProject.dbo.NashvilleHousing
 Group by SoldAsVacant
 order by 2

 Select SoldAsVacant
 , Case When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
 From PortfolioProject.dbo.NashvilleHousing

 Update NashvilleHousing
 Set SoldAsVacant = Case When SoldAsVacant = 'Y' THEN 'Yes'
					When SoldAsVacant = 'N' THEN 'No'
					ELSE SoldAsVacant
					END

-------------------------------------------------------------------------------------------------
-- Remove Duplicates

With RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


-------------------------------------------------------------------------------------------------
-- Delete Unused Columns

Select *
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table PortfolioProject.dbo.NashvilleHousing
Drop Column SaleDate