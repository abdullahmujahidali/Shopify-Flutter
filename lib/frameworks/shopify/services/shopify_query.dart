/// Maximum width of an image is 5760px
const _imageWidth = 700;

/// Maximum height of an image is 5760px
const _imageHeight = 1000;

const _scale = 1;

class ShopifyQuery {
  static String getCollections = '''
    query(\$cursor: String, \$pageSize: Int) {
        collections(first: \$pageSize, after: \$cursor) {
          pageInfo {
            hasNextPage
            hasPreviousPage
          }
          edges {
            cursor
            node {
              id
              title
              description
              image {
                ...imageInformation
              }
            }
          }
        }
    }
    $fragmentImage
    ''';

  static String getProducts = '''
    query(
    \$cursor: String
    \$pageSize: Int
    \$langCode: LanguageCode
    ) @inContext(language: \$langCode) {
      products(first: \$pageSize, after: \$cursor) {
        pageInfo {
          hasNextPage
          hasPreviousPage
        }
        edges {
          cursor
          node {
            ...productInformation
          }
        }
      }
    }
    $fragmentProduct
  ''';

  static String getProductByName = '''
    query(
    \$cursor: String
    \$pageSize: Int
    \$query: String
    \$reverse: Boolean
    \$sortKey: ProductSortKeys
    \$langCode: LanguageCode
    ) @inContext(language: \$langCode) {
        products(first: \$pageSize, after: \$cursor, query: \$query, sortKey: \$sortKey, reverse: \$reverse) {
          pageInfo {
            hasNextPage
            hasPreviousPage
          }
          edges {
            cursor
            node {
              ...productInformation
            }
          }
        }
    }
    $fragmentProduct
  ''';

  static String getProductById = '''
   query (\$id: String, \$langCode: LanguageCode) @inContext(language: \$langCode) {
      products(first: 1, query: \$id) {
        edges {
          node {
            ...productInformation
          }
        }
      }
   }
    $fragmentProduct
  ''';

  static String getProductByPrivateId = '''
   query(
   \$id: ID!
   \$langCode: LanguageCode
   ) @inContext(language: \$langCode) {
      node(id: \$id) {
      ...on Product {
        ...productInformation
       }
     }
   }
   $fragmentProduct
  ''';

  // static String getRelativeProducts = '''
  //   query(\$query: String, \$pageSize: Int) {
  //     shop {
  //       products(first: \$pageSize, query: \$query, sortKey: PRODUCT_TYPE) {
  //         pageInfo {
  //           hasNextPage
  //           hasPreviousPage
  //         }
  //         edges {
  //           cursor
  //           node {
  //             ...productInformation
  //           }
  //         }
  //       }
  //     }
  //   }
  //   $fragmentProduct
  // ''';

  static String getProductByCollection = '''
    query(
    \$categoryId: ID!
    \$pageSize: Int
    \$cursor: String
    \$reverse: Boolean
    \$sortKey: ProductCollectionSortKeys
    \$langCode: LanguageCode
    ) @inContext(language: \$langCode) {
      node(id: \$categoryId) {
        id
        ... on Collection {
          title
          products(first: \$pageSize, after: \$cursor, sortKey: \$sortKey, reverse: \$reverse) {
            pageInfo {
              hasNextPage
              hasPreviousPage
            }
            edges {
              cursor
              node {
                ...productInformation
              }
            }
          }
        }
      }
    }
    $fragmentProduct
  ''';

  static String createCheckout = '''
    mutation checkoutCreate(
      \$input: CheckoutCreateInput! 
      \$langCode: LanguageCode
    ) @inContext(language: \$langCode) {
        checkoutCreate(input: \$input) {
          checkout {
            ...checkoutPriceInformation
          }
          checkoutUserErrors {
            code
            field
            message
          }
        }
    }
    $fragmentCheckoutPrice
  ''';

  static String updateCheckout = '''
    mutation checkoutLineItemsReplace(
      \$lineItems: [CheckoutLineItemInput!]!
      \$checkoutId: ID!
      \$langCode: LanguageCode
    ) @inContext(language: \$langCode) {
      checkoutLineItemsReplace(lineItems: \$lineItems, checkoutId: \$checkoutId) {
        userErrors {
          field
          message
        }
        checkout {
          ...checkoutPriceInformation
        }
      }
    }
    $fragmentCheckoutPrice
  ''';

  static String updateCheckoutAttribute = '''
    mutation checkoutAttributesUpdateV2(
    \$checkoutId: ID! 
    \$input: CheckoutAttributesUpdateV2Input!
    \$langCode: LanguageCode
    ) @inContext(language: \$langCode) {
    checkoutAttributesUpdateV2(checkoutId: \$checkoutId, input: \$input) {
        checkout {
          id
        }
        checkoutUserErrors {
          code
          field
          message
        }
      }
    }
  ''';

  static String updateShippingAddress = '''
    mutation checkoutShippingAddressUpdateV2(
    \$shippingAddress: MailingAddressInput!
    \$checkoutId: ID!) {
      checkoutShippingAddressUpdateV2(shippingAddress: \$shippingAddress, checkoutId: \$checkoutId) {
        userErrors {
          field
          message
        }
        checkout {
          ...checkoutInformation
        }
      }
    }
    $fragmentCheckout
  ''';

  static String applyCoupon = '''
    mutation checkoutDiscountCodeApplyV2(
    \$discountCode: String!
    \$checkoutId: ID!) {
      checkoutDiscountCodeApplyV2(discountCode: \$discountCode, checkoutId: \$checkoutId) {
          checkoutUserErrors {
            field
            message
          }
          checkout {
            ...checkoutPriceInformation
          }
      }
    }
    $fragmentCheckoutPrice
    ''';

  static String removeCoupon = '''
    mutation checkoutDiscountCodeRemove(\$checkoutId: ID!) {
      checkoutDiscountCodeRemove(checkoutId: \$checkoutId) {
        checkoutUserErrors {
          code
          field
          message
        }
        checkout {
          ...checkoutPriceInformation
        }
      }
    }
    $fragmentCheckoutPrice
    ''';

  static String checkoutLinkUser = '''
    mutation checkoutCustomerAssociateV2(\$checkoutId: ID!, \$customerAccessToken: String!) {
    checkoutCustomerAssociateV2(checkoutId: \$checkoutId, customerAccessToken: \$customerAccessToken) {
      checkoutUserErrors {
        field
        message
      }
      customer {
        id
        email
      }
      checkout {
        ...checkoutInformation
      }
    }
  }
  ''';

  static String createCustomer = '''
    mutation customerCreate(\$input: CustomerCreateInput!) {
      customerCreate(input: \$input) {
        userErrors {
          field
          message
        }
        customer {
          id
          email
          firstName
          lastName
          phone
        }
      }
    }
  ''';

  static String customerUpdate = '''
    mutation customerUpdate(\$customerAccessToken: String!, \$customer: CustomerUpdateInput!) {
    customerUpdate(customerAccessToken: \$customerAccessToken, customer: \$customer) {
      customer {
        ...userInformation
      }
      customerAccessToken {
        accessToken
        expiresAt
      }
      customerUserErrors {
        code
        field
        message
      }
    }
  }
  $fragmentUser
  ''';

  static String createCustomerToken = '''
    mutation customerAccessTokenCreate(\$input: CustomerAccessTokenCreateInput!) {
    customerAccessTokenCreate(input: \$input) {
      userErrors {
        field
        message
      }
      customerAccessToken {
        accessToken
        expiresAt
      }
    }
  }
  ''';

  static String renewCustomerToken = '''
    mutation customerAccessTokenRenew(\$customerAccessToken: String!) {
      customerAccessTokenRenew(customerAccessToken: \$customerAccessToken) {
        userErrors {
          field
          message
        }
        customerAccessToken {
          accessToken
          expiresAt
        }
      }
    }
  ''';

  static String getCustomerInfo = '''
    query(\$accessToken: String!) {
      customer(customerAccessToken: \$accessToken) {
        id
        email
        createdAt
        displayName
        phone
        firstName
        lastName
        defaultAddress {
          address1
          address2
          city
          firstName
          id
          lastName
          zip
          phone
          name
          latitude
          longitude
          province
          country
          countryCode
        }
        addresses(first: 10) {
          pageInfo {
            hasNextPage
            hasPreviousPage
          }
          edges {
            node {
              address1
              address2
              city
              firstName
              id
              lastName
              zip
              phone
              name
              latitude
              longitude
              province
              country
              countryCode
            }
          }
        }
      }
    }
  ''';

  static String getPaymentSettings = '''
    query {
      shop {
        paymentSettings {
          cardVaultUrl
          acceptedCardBrands
          countryCode
          currencyCode
          shopifyPaymentsAccountId
          supportedDigitalWallets
        }
      }
    }
  ''';

  static String checkoutWithCreditCard = '''
    mutation checkoutCompleteWithCreditCardV2(\$checkoutId: ID!, \$payment: CreditCardPaymentInputV2!) {
      checkoutCompleteWithCreditCardV2(checkoutId: \$checkoutId, payment: \$payment) {
        userErrors {
          field
          message
        }
        checkout {
          id
        }
        payment {
          id
          amountV2 {
            amount
          }
        }
      }
    }
  ''';

  static String checkoutWithFree = '''
    mutation checkoutCompleteFree(\$checkoutId: ID!) {
      checkoutCompleteFree(checkoutId: \$checkoutId) {
        userErrors {
          field
          message
        }
        checkout {
          id
        }
        payment {
          id
        }
      }
    }
  ''';

  static String getOrder = '''
    query(\$cursor: String, \$pageSize: Int, \$customerAccessToken: String!) {
      customer(customerAccessToken: \$customerAccessToken) {
        orders(first: \$pageSize, after: \$cursor, reverse: true) {
          pageInfo {
            hasNextPage
            hasPreviousPage
          }
          edges {
            cursor
            node {
              id
              financialStatus
              processedAt
              orderNumber
              totalPrice {
                amount
              }
              statusUrl
              totalTax {
                amount
              }
              subtotalPrice {
                amount
              }
              shippingAddress {
                address1
                address2
                city
                company
                country
                firstName
                id
                lastName
                zip
                provinceCode
                phone
                province
                name
                longitude
                latitude
                lastName
              }
              lineItems(first: \$pageSize) {
                pageInfo {
                  hasNextPage
                  hasPreviousPage
                }
                edges {
                  node {
                    quantity
                    title
                    originalTotalPrice{
                      amount
                    }
                    variant {
                      title
                      image {
                        ...imageInformation
                      }
                      price {
                        amount
                      }
                      selectedOptions {
                        name
                        value
                      }
                      product {
                        id
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    $fragmentImage
  ''';

  static String getArticle = '''
    query(
    \$cursor: String
    \$pageSize: Int
    \$langCode: LanguageCode
    ) @inContext(language: \$langCode) {
        articles(
          first: \$pageSize 
          after: \$cursor
          sortKey: PUBLISHED_AT 
          reverse: true
          ) {
            pageInfo {
              hasNextPage
              hasPreviousPage
            }
            edges {
              cursor
              node {
                onlineStoreUrl
                title
                excerpt
                authorV2 {
                  name
                }
                id
                content
                contentHtml
                image {
                  ...imageInformation
                }
                publishedAt
              }
            }
          }
    }
    $fragmentImage
  ''';

  static String resetPassword = '''
    mutation customerRecover(\$email: String!) {
    customerRecover(email: \$email) {
      customerUserErrors {
        code
        field
        message
      }
    }
}
  ''';

  static String getProductByHandle = '''
   query (\$handle: String!) {
      productByHandle(handle: \$handle) {
        ...productInformation
      }
   }
   $fragmentProduct
''';

  static String getProductWithCategoryAndName = '''
   query (\$id: ID!) {
      collection(id: \$id) {
        products(first: \$pageSize, filters: [
          {
            
          }
          # {
          #   productType: "shoes"
          # },
          # {
          #   productVendor: "ACORELLE"
          # },
          # {
          #   productMetafield: {
          #     namespace: "custom",
          #     key:"type_de_cheveux",
          #     value :"Tous types de cheveux"
          #   }
          # }
          # {
          #   variantOption: {
          #       name: "color",
          #       value: "blue"
          #   }
          # }
        ]){
          nodes{
            ...productInformation
          }
        }
      }
   }
   $fragmentProduct
   ''';

  static String deleteToken = '''
    mutation customerAccessTokenDelete(\$customerAccessToken: String!) {
      customerAccessTokenDelete(customerAccessToken: \$customerAccessToken) {
        deletedAccessToken
        deletedCustomerAccessTokenId
        userErrors {
          field
          message
        }
      }
    }
  ''';

  static String getCheckout = '''
    query(\$checkoutId: ID!) {
        node(id: \$checkoutId) {
            ... on Checkout {
                ...checkoutInformation
            }
        }
    } 
    $fragmentCheckout   
  ''';

  static const fragmentUser = '''
      fragment userInformation on Customer {
        id
        email
        createdAt
        displayName
        phone
        firstName
        lastName
        defaultAddress {
          address1
          address2
          city
          firstName
          id
          lastName
          zip
          phone
          name
          latitude
          longitude
          province
          country
          countryCode
        }
        addresses(first: 10) {
          pageInfo {
            hasNextPage
            hasPreviousPage
          }
          edges {
            node {
              address1
              address2
              city
              firstName
              id
              lastName
              zip
              phone
              name
              latitude
              longitude
              province
              country
              countryCode
            }
          }
        }
      }
  ''';

  static const fragmentProduct = '''
      fragment productInformation on Product {
          id
          title
          vendor
          description
          descriptionHtml
          totalInventory
          availableForSale
          productType
          onlineStoreUrl
          tags
          collections(first: 10) {
            edges {
              node {
                id
                title
              }
            }
          }
          options {
            id
            name
            values
          }
          variants(first: 250) {
            pageInfo {
              hasNextPage
              hasPreviousPage
            }
            edges {
              node {
                id
                title
                availableForSale
                quantityAvailable
                selectedOptions {
                  name
                  value
                }
                image {
                  ...imageInformation
                }
                price {
                  amount
                  currencyCode
                }
                compareAtPrice {
                  amount
                  currencyCode
                }
              }
            }
          }
          images(first: 250) {
            edges {
              node {
                ...imageInformation
              }
            }
          }
          featuredImage {
            ...imageInformation
          }
        }
        $fragmentImage
''';

  static const fragmentImage = '''
    fragment imageInformation on Image {
      url(transform: {maxWidth: $_imageWidth, maxHeight: $_imageHeight, scale: $_scale})
      width
      height
    }
  ''';

  static const fragmentCheckoutPrice = '''
    fragment checkoutPriceInformation on Checkout {
      id
      webUrl
      taxesIncluded
      discountApplications(first: 10) {
        edges {
          node {
            __typename
            ... on DiscountCodeApplication {
              allocationMethod
              applicable
              code
              targetSelection
              targetType
              value {
                __typename
                ... on MoneyV2 {
                  amount
                }
                ... on PricingPercentageValue {
                  percentage
                }
              }
            }
          }
        }
      }
      subtotalPrice {
        amount
        currencyCode
      }
      totalTax {
        amount
        currencyCode
      }
      totalPrice {
        amount
        currencyCode
      }
      paymentDue {
        amount
        currencyCode
      }
    } 
  ''';

  static const fragmentCheckout = '''
    fragment checkoutInformation on Checkout {
      ...checkoutPriceInformation
      availableShippingRates {
        ready
        shippingRates {
          handle
          price {
            amount
            currencyCode
          }
          title
        }
      }
      shippingLine {
        price {
          amount
          currencyCode
        }
        title
        handle
      }
      shippingAddress {
        address1
        address2
        city
        firstName
        id
        lastName
        zip
        phone
        name
        latitude
        longitude
        province
        country
      }
    }
    $fragmentCheckoutPrice
''';
}
