// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// OpenZeppelin 라이브러리: 안전하고 표준화된 코드를 쉽게 사용하게 해줍니다.
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract KaiaNFILending is Ownable, ReentrancyGuard {

    // --- 상태 변수 (State Variables) ---
    // 우리 프로토콜이 사용할 토큰들의 주소를 저장합니다.
    IERC20 public usdtToken;      // USDT 토큰 컨트랙트
    IERC721 public nftCollection; // 담보로 받을 NFT 컬렉션 컨트랙트

    // 대출 정책 관련 변수들
    uint256 public floorPrice;              // NFT 최저가 (단위: USDT)
    uint256 public ltvRatio = 50;           // 담보인정비율 (LTV) 50%
    uint256 public interestRate = 10;       // 연이율 (APR) 10%
    uint256 public constant LOAN_DURATION = 7 days; // 대출 기간 7일로 고정

    // --- 핵심 데이터 구조 (Data Structure) ---
    // 개별 대출의 상세 정보를 저장하기 위한 구조체입니다.
    struct Loan {
        address borrower;   // 돈을 빌린 사람
        uint256 tokenId;    // 담보로 맡긴 NFT의 ID
        uint256 loanAmount; // 빌린 원금
        uint256 startTime;  // 대출 시작 시간 (타임스탬프)
        bool active;        // 대출이 현재 유효한지 여부
    }

    // NFT 토큰 ID를 사용해 해당 대출 정보를 찾아올 수 있는 '데이터베이스' 역할을 합니다.
    mapping(uint256 => Loan) public loans;

    // --- 이벤트 (Events) ---
    // 프론트엔드에 특정 사건이 발생했음을 알려주기 위한 신호입니다.
    event LoanCreated(address indexed borrower, uint256 indexed tokenId, uint256 amount);
    event LoanRepaid(address indexed borrower, uint256 indexed tokenId);
    event Liquidated(uint256 indexed tokenId, address liquidator);

}